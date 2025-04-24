#include "enginesmodel.h"

EnginesModel::EnginesModel(QObject *parent)
    : QAbstractListModel{parent}
{

}

int EnginesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_engines.count();
}

QVariant EnginesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_engines.size())
        return QVariant();

    const auto& engine = m_engines[index.row()];


    switch (role)
    {
    case RPMPercentRole:
        return engine.rpm_percent;
    default:
        return QVariant();

    }
}

bool EnginesModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() >= m_engines.size())
        return false;

    auto& engine = m_engines[index.row()];

    if (role == RPMPercentRole && value.toInt() != engine.rpm_percent)
    {
        engine.rpm_percent = value.toInt();
        emit dataChanged(index, index);
        return true;
    }

    return false;
}

QHash<int, QByteArray> EnginesModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "enginename";
    roles[RPMPercentRole] = "rpmpercent";

    return roles;
}

Qt::ItemFlags EnginesModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

void EnginesModel::addEngine(const QString &name, int rpm)
{
    beginInsertRows(QModelIndex(), m_engines.size(), m_engines.size());

    engine_t engine { name, rpm };

    m_engines.append(engine);

    endInsertRows();
}

QVariantMap EnginesModel::get(int row) const
{
    if (row < 0 || row >= m_engines.size())
        return QVariantMap();

    const engine_t& engine = m_engines[row];

    QVariantMap map;

    map["name"] = engine.name;
    map["rpmpercent"] = engine.rpm_percent;

    return map;
}

QVariantMap EnginesModel::get(const QString &name) const
{
    for (const auto& engine: m_engines)
    {
        if (engine.name == name)
        {
            QVariantMap map;

            map["name"] = engine.name;
            map["rpmpercent"] = engine.rpm_percent;

            return map;
        }
    }

    return QVariantMap();
}
