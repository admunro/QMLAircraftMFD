#include "fueltankmodel.h"

FuelTankModel::FuelTankModel(QObject* parent)
		: QAbstractListModel {parent}
{
}

int FuelTankModel::rowCount(const QModelIndex& parent) const
{
	if (parent.isValid())
		return 0;

	return m_fueltanks.count();
}

QVariant FuelTankModel::data(const QModelIndex& index, int role) const
{
	if (!index.isValid() || index.row() >= m_fueltanks.size())
		return QVariant();

	const auto& fueltank = m_fueltanks[index.row()];

	switch (role)
	{
		case NameRole:
			return fueltank.name;
		case Capacity_kgRole:
			return fueltank.capacity_kg;
		case Fill_level_kgRole:
			return fueltank.fill_level_kg;
		default:
			return QVariant();
	}
}

bool FuelTankModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
	if (!index.isValid() || index.row() >= m_fueltanks.size())
		return false;

	auto& fueltank = m_fueltanks[index.row()];
	bool changed = false;

	switch (role)
	{
	case NameRole:
		if (value.toString() != fueltank.name)
		{
			fueltank.name = value.toString();
			changed = true;
		}
		break;

	case Capacity_kgRole:
		if (value.toInt() != fueltank.capacity_kg)
		{
			fueltank.capacity_kg = value.toInt();
			changed = true;
		}
		break;

	case Fill_level_kgRole:
		if (value.toInt() != fueltank.fill_level_kg)
		{
			fueltank.fill_level_kg = value.toInt();
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

QHash<int, QByteArray> FuelTankModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[NameRole] = "name";
	roles[Capacity_kgRole] = "capacity_kg";
	roles[Fill_level_kgRole] = "fill_level_kg";

	return roles;
}

Qt::ItemFlags FuelTankModel::flags(const QModelIndex& index) const
{
	if (!index.isValid())
		return Qt::NoItemFlags;

	return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

void FuelTankModel::add(const QString& name,
                        int capacity_kg,
                        int fill_level_kg)
{
	beginInsertRows(QModelIndex(), m_fueltanks.size(), m_fueltanks.size());

	fueltank_t fueltank;

	fueltank.name = name;
	fueltank.capacity_kg = capacity_kg;
	fueltank.fill_level_kg = fill_level_kg;
	m_fueltanks.append(fueltank);

	endInsertRows();
}

QVariantMap FuelTankModel::getByIndex(int row) const
{
	if (row < 0 || row >= m_fueltanks.size())
		return QVariantMap();

	const auto& fueltank = m_fueltanks[row];

	QVariantMap map;

	map["name"] = fueltank.name;
	map["capacity_kg"] = fueltank.capacity_kg;
	map["fill_level_kg"] = fueltank.fill_level_kg;

	return map;
}

QVariantMap FuelTankModel::getByName(const QString& name) const
{
	for (const auto& fueltank: m_fueltanks)
	{
		if (fueltank.name == name)
		{
			QVariantMap map;

			map["name"] = fueltank.name;
			map["capacity_kg"] = fueltank.capacity_kg;
			map["fill_level_kg"] = fueltank.fill_level_kg;

			return map;
		}
	}

	return QVariantMap();
}
