#include "weaponstationmodel.h"

#include <QDebug>

WeaponStationModel::WeaponStationModel(QObject* parent)
		: QAbstractListModel {parent}
{
}

int WeaponStationModel::rowCount(const QModelIndex& parent) const
{
	if (parent.isValid())
		return 0;

	return m_weaponstations.count();
}

QVariant WeaponStationModel::data(const QModelIndex& index, int role) const
{
	if (!index.isValid() || index.row() >= m_weaponstations.size())
		return QVariant();

	const auto& weaponstation = m_weaponstations[index.row()];

	switch (role)
	{
		case NameRole:
			return weaponstation.name;
		case Weapon_typeRole:
			return weaponstation.weapon_type;
		case Weapon_categoryRole:
			return weaponstation.weapon_category;
		case SelectedRole:
			return weaponstation.selected;
		case LoadedRole:
			return weaponstation.loaded;
		default:
			return QVariant();
	}
}

bool WeaponStationModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
	if (!index.isValid() || index.row() >= m_weaponstations.size())
		return false;

	auto& weaponstation = m_weaponstations[index.row()];
	bool changed = false;

	switch (role)
	{
	case NameRole:
		if (value.toString() != weaponstation.name)
		{
			weaponstation.name = value.toString();
			changed = true;
		}
		break;

	case Weapon_typeRole:
		if (value.toString() != weaponstation.weapon_type)
		{
			weaponstation.weapon_type = value.toString();
			changed = true;
		}
		break;

	case Weapon_categoryRole:
		if (value.toString() != weaponstation.weapon_category)
		{
			weaponstation.weapon_category = value.toString();
			changed = true;
		}
		break;

	case SelectedRole:
        if (value.toBool() != weaponstation.selected)
        {
            // We need a reset model here rather than just updating one
            // model index, because selecting one weapon station
            // implies automatically deselecting any existing selections,
            // hence we need to emit a signal which covers the whole model
            // and not just the index that's been clicked on.
            beginResetModel();

            for (auto& station : m_weaponstations)
            {
                station.selected = false;
            }

            weaponstation.selected = value.toBool();

            endResetModel();
        }
		break;

	case LoadedRole:
		if (value.toBool() != weaponstation.loaded)
		{
			weaponstation.loaded = value.toBool();
			changed = true;
		}
		break;

	default:
		return false;
	}

	if (changed)
	{
		emit dataChanged(index, index);
		return true;
	}

	return false;

}

QHash<int, QByteArray> WeaponStationModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[NameRole] = "name";
	roles[Weapon_typeRole] = "weapon_type";
	roles[Weapon_categoryRole] = "weapon_category";
	roles[SelectedRole] = "selected";
	roles[LoadedRole] = "loaded";

	return roles;
}

Qt::ItemFlags WeaponStationModel::flags(const QModelIndex& index) const
{
	if (!index.isValid())
		return Qt::NoItemFlags;

	return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

void WeaponStationModel::add(const QString& name,
                             const QString& weapon_type,
                             const QString& weapon_category,
                             bool selected,
                             bool loaded)
{
	beginInsertRows(QModelIndex(), m_weaponstations.size(), m_weaponstations.size());

	weaponstation_t weaponstation;

	weaponstation.name = name;
	weaponstation.weapon_type = weapon_type;
	weaponstation.weapon_category = weapon_category;
	weaponstation.selected = selected;
	weaponstation.loaded = loaded;
	m_weaponstations.append(weaponstation);

	endInsertRows();
}

QVariantMap WeaponStationModel::getByIndex(int row) const
{
	if (row < 0 || row >= m_weaponstations.size())
		return QVariantMap();

	const auto& weaponstation = m_weaponstations[row];

	QVariantMap map;

	map["name"] = weaponstation.name;
	map["weapon_type"] = weaponstation.weapon_type;
	map["weapon_category"] = weaponstation.weapon_category;
	map["selected"] = weaponstation.selected;
	map["loaded"] = weaponstation.loaded;

	return map;
}

QVariantMap WeaponStationModel::getByName(const QString& name) const
{
	for (const auto& weaponstation: m_weaponstations)
	{
		if (weaponstation.name == name)
		{
			QVariantMap map;

			map["name"] = weaponstation.name;
			map["weapon_type"] = weaponstation.weapon_type;
			map["weapon_category"] = weaponstation.weapon_category;
			map["selected"] = weaponstation.selected;
			map["loaded"] = weaponstation.loaded;

			return map;
		}
	}

	return QVariantMap();
}
