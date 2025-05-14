import xml.etree.ElementTree as ET

indent = ''

simpleTypes = ['float', 'int', 'double', 'unsigned int', 'char', 'bool']


def increase_indent():
    global indent

    indent += '\t'


def decrease_indent():
    global indent

    if len(indent) > 0:
        indent = indent[:-1]
    else:
        print("Can't decrease indent past zero!")


def parse_includes(includes):

    output = []

    output.append('#pragma once')
    output.append('')
    output.append('#include <QAbstractListModel>')
    output.append('#include <QtQml/qqmlregistration.h>')

    if includes is not None:
        for include in includes:
            output.append('#include <' + include.attrib['name'] + '>')

    return output


def parse_struct(members, class_name):

    global indent

    struct = []

    struct_name = class_name.removesuffix('Model').lower() + '_t'

    struct.append(indent + 'struct ' + struct_name)
    struct.append(indent + '{')

    increase_indent()

    for member in members:

        line = indent + member.attrib['type'] + " " + member.attrib['name']

        if 'initialValue' in member.attrib.keys():
            line += (' { ' + member.attrib['initialValue'] + ' }')

        line += ';'

        struct.append(line)

    decrease_indent()

    struct.append(indent + '};')

    return struct_name, struct


def parse_enum(members, class_name):

    global indent

    enum = []

    enum.append(indent + 'enum ' + class_name + 'Roles')
    enum.append(indent + '{')
    increase_indent()


    for member in members:

        if member == members[0]:
            enum.append(indent + member.attrib['name'].capitalize() + 'Role = Qt::UserRole + 1,')
        elif member == members[-1]:
            enum.append(indent + member.attrib['name'].capitalize() + 'Role')
        else:
            enum.append(indent + member.attrib['name'].capitalize() + 'Role,')

    decrease_indent()

    enum.append(indent + '};')
    enum.append('')
    enum.append(indent + 'Q_ENUM(' + class_name + 'Roles)')

    return enum


def parse_member_parameters(members):

    parameters = []

    for member in members:

        member_line = ''

        name = member.attrib['name']
        data_type = member.attrib['type']

        if data_type in simpleTypes:
            member_line += data_type + ' ' + name
        else:
            member_line += 'const ' + data_type + '& ' + name

        parameters.append(member_line)

    return parameters


def create_header_file(model, class_name, includes, members, vector_name):
    global indent
    indent = ''

    header_file = []

    header_file.extend(parse_includes(includes))

    header_file.append('')
    header_file.append('class ' + class_name + ' : public QAbstractListModel')
    header_file.append('{')
    increase_indent()
    header_file.append(indent + 'Q_OBJECT')
    header_file.append(indent + 'QML_ELEMENT')
    decrease_indent()
    header_file.append('')
    header_file.append(indent + 'public:')
    header_file.append('')
    increase_indent()

    struct_name, struct = parse_struct(members, class_name)

    header_file.extend(struct)

    header_file.append('')

    header_file.extend(parse_enum(members, class_name))
    header_file.append('')

    header_file.append(indent + 'explicit ' + class_name + '(QObject* parent = nullptr);')
    header_file.append('')
    header_file.append(indent + 'int rowCount(const QModelIndex& parent = QModelIndex()) const override;')
    header_file.append(indent + 'QVariant data(const QModelIndex& index, int role) const override;')
    header_file.append(indent + 'bool setData(const QModelIndex& index, const QVariant& value, int role) override;')
    header_file.append(indent + 'QHash<int, QByteArray> roleNames() const override;')
    header_file.append(indent + 'Qt::ItemFlags flags(const QModelIndex& index) const override;')
    header_file.append('')


    add_entity_header = indent + 'Q_INVOKABLE void add' + '(' 
    add_entity_indent = indent + ' ' * len(add_entity_header.removeprefix('\t'))
    add_entity_members = parse_member_parameters(members)

    if len(add_entity_members) == 1:
        header_file.append(add_entity_indent + add_entity_header + add_entity_members[0] + ');')
    else:
        header_file.append(add_entity_header + add_entity_members[0] + ',')
        for member in add_entity_members[1:]:
            if member != add_entity_members[-1]:
                header_file.append(add_entity_indent + member + ',')
            else:
                header_file.append(add_entity_indent + member + ');')

    header_file.append('')
    header_file.append(indent + 'Q_INVOKABLE QVariantMap getByIndex(int row) const;')
    header_file.append(indent + 'Q_INVOKABLE QVariantMap getByName(const QString& name) const;')
    header_file.append('')
    header_file.append('')

    decrease_indent()
    header_file.append(indent + 'private:')
    header_file.append('')

    increase_indent()

    header_file.append(indent + 'QVector<' + struct_name + '> ' + vector_name + ';')
    header_file.append('')

    decrease_indent()

    header_file.append('};')

    with open('generated_' + class_name.lower() + '.h', 'w') as file:
        for line in header_file:
            file.write(f"{line}\n")


def create_source_file(model, class_name, members, vector_name):

    global indent
    indent = ''

    simple_class_name = class_name.removesuffix('Model')
    instance_name = simple_class_name.lower()

    source_file = []

    # includes
    source_file.append('#include "' + class_name.lower() + '.h"')
    source_file.append('')

    # constructor
    source_file.append(class_name + '::' + class_name + '(QObject* parent)')
    increase_indent()
    increase_indent()
    source_file.append(indent + ': QAbstractListModel {parent}')
    decrease_indent()
    decrease_indent()
    source_file.append('{')
    source_file.append('}')
    source_file.append('')


    # Row Count
    source_file.append('int ' + class_name + '::rowCount(const QModelIndex& parent) const')
    source_file.append('{')
    increase_indent()
    source_file.append(indent + 'if (parent.isValid())')
    increase_indent()
    source_file.append(indent + 'return 0;')
    decrease_indent()
    source_file.append('')
    source_file.append(indent + 'return ' + vector_name + '.count();')
    decrease_indent()
    source_file.append('}')
    source_file.append('')

    # data
    source_file.append('QVariant ' + class_name + '::data(const QModelIndex& index, int role) const')
    source_file.append('{')
    increase_indent()
    source_file.append(indent + 'if (!index.isValid() || index.row() >= ' + vector_name + '.size())')
    increase_indent()
    source_file.append(indent + 'return QVariant();')
    decrease_indent()
    source_file.append('')

    source_file.append(indent + 'const auto& ' + instance_name + ' = ' + vector_name + '[index.row()];')
    source_file.append('')
    source_file.append(indent + 'switch (role)')
    source_file.append(indent + '{')

    increase_indent()
    for member in members:
        source_file.append(indent + 'case ' + member.attrib['name'].capitalize() + 'Role:')
        increase_indent()
        source_file.append(indent + 'return ' + instance_name + '.' + member.attrib['name'] + ';')
        decrease_indent()

    source_file.append(indent + 'default:')
    increase_indent()
    source_file.append(indent + 'return QVariant();')
    decrease_indent()
    decrease_indent()
    source_file.append(indent + '}')
    decrease_indent()
    source_file.append(indent + '}')
    source_file.append('')

    # setData
    source_file.append(indent + 'bool ' + class_name + '::setData(const QModelIndex& index, const QVariant& value, int role)')
    source_file.append('{')
    increase_indent()
    source_file.append(indent + 'if (!index.isValid() || index.row() >= ' + vector_name + '.size())')
    increase_indent()
    source_file.append(indent + 'return false;')
    source_file.append('')
    decrease_indent()

    source_file.append(indent + 'auto& ' + instance_name + ' = ' + vector_name + '[index.row()];')
    source_file.append(indent + 'bool changed = false;')
    source_file.append('')
    source_file.append(indent + 'switch (role)')
    source_file.append(indent + '{')

    for member in members:

        role_name = member.attrib['name'].capitalize() + 'Role'
        type_name = member.attrib['type'].capitalize()

        source_file.append(indent + 'case ' + role_name + ':')
        increase_indent()
        if type_name == 'Qstring':
            source_file.append(indent + 'if (value.toString() != ' + instance_name + '.' + member.attrib['name'] + ')')
            source_file.append(indent + '{')
            increase_indent()
            source_file.append(indent + instance_name + '.' + member.attrib['name'] + ' = value.toString();')
        else:
            source_file.append(indent + 'if (value.to' + type_name + '() != ' + instance_name + '.' + member.attrib['name'] + ')')
            source_file.append(indent + '{')
            increase_indent()
            source_file.append(indent + instance_name + '.' + member.attrib['name'] + ' = value.to' + type_name + '();')

        source_file.append(indent + 'changed = true;')
        decrease_indent()
        source_file.append(indent + '}')
        source_file.append(indent + 'break;')
        source_file.append('')
        decrease_indent()

    source_file.append(indent + 'default:')
    increase_indent()
    source_file.append(indent + 'return false;')
    decrease_indent()
    source_file.append(indent + '}')
    source_file.append('')
    source_file.append(indent + 'if (changed)')
    source_file.append(indent + '{')
    increase_indent()
    source_file.append(indent + 'emit dataChanged(index, index);')
    source_file.append(indent + 'return true;')
    decrease_indent()
    source_file.append(indent + '}')
    source_file.append('')
    source_file.append(indent + 'return false;')
    decrease_indent()
    source_file.append('')
    source_file.append(indent + '}')
    source_file.append('')

    # roleNames
    source_file.append('QHash<int, QByteArray> ' + class_name + '::roleNames() const')
    source_file.append('{')
    increase_indent()

    source_file.append(indent + 'QHash<int, QByteArray> roles;')

    for member in members:
        source_file.append(indent + 'roles[' + member.attrib['name'].capitalize() + 'Role]' + ' = "' + member.attrib['name'] + '";')

    source_file.append('')
    source_file.append(indent + 'return roles;')
    decrease_indent()
    source_file.append('}')
    source_file.append('')

    # flags
    source_file.append('Qt::ItemFlags ' + class_name + '::flags(const QModelIndex& index) const')
    source_file.append('{')
    increase_indent()
    source_file.append(indent + 'if (!index.isValid())')
    increase_indent()
    source_file.append(indent + 'return Qt::NoItemFlags;')  
    source_file.append('')
    decrease_indent()
    source_file.append(indent + 'return Qt::ItemIsEditable | QAbstractListModel::flags(index);')
    source_file.append('}')
    source_file.append('')
    decrease_indent()

    # add
    add_entity_header = 'void ' + class_name + '::add' + '('
    add_entity_indent = ' ' * len(add_entity_header)
    add_entity_members = parse_member_parameters(members)

    if len(add_entity_members) == 1:
        source_file.append(add_entity_indent + add_entity_header + add_entity_members[0] + ');')
    else:
        source_file.append(add_entity_header + add_entity_members[0] + ',')
        for member in add_entity_members[1:]:
            if member != add_entity_members[-1]:
                source_file.append(add_entity_indent + member + ',')
            else:
                source_file.append(add_entity_indent + member + ')')

    source_file.append('{')
    increase_indent()
    source_file.append(indent + 'beginInsertRows(QModelIndex(), ' + vector_name + '.size()' + ', ' + vector_name + '.size());' )
    source_file.append('')

    source_file.append(indent + instance_name + '_t ' + instance_name + ';')
    source_file.append('')

    for member in members:
        source_file.append(indent + instance_name + '.' + member.attrib['name'] + ' = ' + member.attrib['name'] + ';')


    source_file.append(indent + vector_name + '.append(' + instance_name + ');')
    source_file.append('')

    source_file.append(indent + 'endInsertRows();')
    decrease_indent()
    source_file.append(indent + '}')

    source_file.append('')

    # getByIndex
    source_file.append('QVariantMap ' + class_name + '::getByIndex(int row) const')
    source_file.append('{')
    increase_indent()
    source_file.append(indent + 'if (row < 0 || row >= ' + vector_name + '.size())')
    increase_indent()
    source_file.append(indent + 'return QVariantMap();')
    decrease_indent()
    source_file.append('')
    source_file.append(indent + 'const auto& ' + instance_name + ' = ' + vector_name + '[row];')
    source_file.append('')
    source_file.append(indent + 'QVariantMap map;')
    source_file.append('')

    for member in members:
        attrib_name = member.attrib['name']
        source_file.append(indent + 'map["' + attrib_name + '"] = ' + instance_name + '.' + attrib_name + ';')

    source_file.append('')
    source_file.append(indent + 'return map;')
    decrease_indent()
    source_file.append(indent + '}')
    source_file.append('')


    #getByName
    source_file.append('QVariantMap ' + class_name + '::getByName(const QString& name) const')
    source_file.append('{')
    increase_indent()
    source_file.append(indent + 'for (const auto& ' + instance_name + ': ' + vector_name + ')')
    source_file.append(indent + '{')
    increase_indent()
    source_file.append(indent + 'if (' + instance_name + '.name == name)')
    source_file.append(indent + '{')
    increase_indent()
    source_file.append(indent + 'QVariantMap map;')
    source_file.append('')

    for member in members:
        attrib_name = member.attrib['name']
        source_file.append(indent + 'map["' + attrib_name + '"] = ' + instance_name + '.' + attrib_name + ';')

    source_file.append('')
    source_file.append(indent + 'return map;')
    decrease_indent()
    source_file.append(indent + '}')
    decrease_indent()
    source_file.append(indent + '}')
    source_file.append('')
    source_file.append(indent + 'return QVariantMap();')
    decrease_indent()
    source_file.append(indent + '}')

    with open('generated_' + class_name.lower() + '.cpp', 'w') as file:
        for line in source_file:
            file.write(f"{line}\n")


def parse_models(filename):

    global indent

    models = ET.parse(filename).getroot().findall('model')

    for model in models:

        includes = model.findall('include')
        members = model.findall('member')

        class_name = (model.attrib['name'] + 'Model')

        if 'plural' in model.attrib.keys():
            vector_name = ('m_' + model.attrib['plural']).lower()
        else:
            vector_name = ('m_' + model.attrib['name'] + 's').lower()

        create_header_file(model, class_name, includes, members, vector_name)
        create_source_file(model, class_name, members, vector_name)


if __name__ == "__main__":
    parse_models('models.xml')