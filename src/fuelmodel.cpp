#include "fuelmodel.h"

FuelModel::FuelModel(QObject* parent):
        QAbstractListModel { parent }
{
}

int FuelModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return m_fuelTanks.count();
}

QVariant FuelModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_fuelTanks.size())
        return QVariant();

    const FuelModel::fuelTank_t& fuelTank = m_fuelTanks[index.row()];


    switch (role)
    {
        case fillLevelRole:
            return fuelTank.fill_level_kg;
        case capacityRole:
            return fuelTank.capacity_kg;
        case nameRole:
            return fuelTank.tankName;
        default:
            return QVariant();

    }
}

QHash<int, QByteArray> FuelModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[fillLevelRole] = "fillLevel";
    roles[capacityRole] = "capacity";
    roles[nameRole] = "name";

    return roles;
}


void FuelModel::addFuelTank(const QString& name,
                            int capacity_kg,
                            int fillLevel_kg)
{
    if (capacity_kg < 0  || fillLevel_kg < 0 || fillLevel_kg > capacity_kg)
    {
        qDebug() << "Invalid parameters for creating a fuel tank: " << name
                 << " Capacity: " << capacity_kg
                 << " Fill Level: " << fillLevel_kg;
        return;
    }

    beginInsertRows(QModelIndex(), m_fuelTanks.size(), m_fuelTanks.size());

    fuelTank_t tank { name, capacity_kg, fillLevel_kg };

    m_fuelTanks.append(tank);

}


QVariantMap FuelModel::get(int row) const
{
    if (row < 0 || row >= m_fuelTanks.size())
        return QVariantMap();

    const fuelTank_t& tank = m_fuelTanks[row];

    QVariantMap map;

    map["name"] = tank.tankName;
    map["capacity"] = tank.capacity_kg;
    map["fillLevel"] = tank.fill_level_kg;

    return map;

}


bool FuelModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid() || index.row() >= m_fuelTanks.size())
        return false;

    fuelTank_t &tank = m_fuelTanks[index.row()];

    if (role == fillLevelRole && value.toInt() != tank.fill_level_kg)
    {
        tank.fill_level_kg = value.toInt();
        emit dataChanged(index, index);
        return true;
    }

    // Don't respond to requests to change the tank's capacity!

    return false;

}


Qt::ItemFlags FuelModel::flags(const QModelIndex& index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}



