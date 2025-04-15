#include <numbers>
#include <cmath>

#include <QGeoCoordinate>

#include "entitymodel.h"



void EntityModel::updateEntities()
{
    for (int i = 0; i < m_entities.size(); i++)
    {
        auto& entity = m_entities[i];

        auto newPosition = calculateNewPosition(entity.position,
                                                entity.heading_deg,
                                                entity.speed_kts,
                                                this->updateRateMilliseconds);

        entity.position.setLatitude(newPosition.latitude());
        entity.position.setLongitude(newPosition.longitude());

        QModelIndex index = createIndex(i, 0);
        emit dataChanged(index, index, { LatitudeRole, LongitudeRole });
    }
}


EntityModel::EntityModel(QObject *parent, double updateRateMS)
    : QAbstractListModel{parent},
    updateRateMilliseconds (updateRateMS)
{
    this->timer = new QTimer();

    QObject::connect(this->timer, &QTimer::timeout, this, &EntityModel::updateEntities);

    timer->start(updateRateMilliseconds);

}

int EntityModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return m_entities.count();
}


QVariant EntityModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_entities.size())
        return QVariant();

    const Entity &entity = m_entities[index.row()];

    switch (role) {
    case IdRole:
        return entity.id;
    case NameRole:
        return entity.name;
    case LatitudeRole:
        return entity.position.latitude();
    case LongitudeRole:
        return entity.position.longitude();
    case TypeRole:
        return entity.type;
    case HeadingRole:
        return entity.heading_deg;
    case SpeedRole:
        return entity.speed_kts;
    default:
        return QVariant();
    }
}


QHash<int, QByteArray> EntityModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "entityId";
    roles[NameRole] = "name";
    roles[LatitudeRole] = "latitude";
    roles[LongitudeRole] = "longitude";
    roles[TypeRole] = "type";
    roles[HeadingRole] = "heading";
    roles[SpeedRole] = "speed";

    return roles;
}


void EntityModel::addEntity(const QString &id,
                            const QString &name,
                            double latitude,
                            double longitude,
                            const QString &type,
                            double speed_kts,
                            double heading_deg)
{
    beginInsertRows(QModelIndex(), m_entities.size(), m_entities.size());

    Entity entity;
    entity.id = id;
    entity.name = name;
    entity.position = QGeoCoordinate(latitude, longitude);
    entity.type = type;
    entity.heading_deg = heading_deg;
    entity.speed_kts = speed_kts;

    m_entities.append(entity);

    endInsertRows();
}


void EntityModel::removeEntity(const QString &id)
{
    for (int i = 0; i < m_entities.size(); ++i)
    {
        if (m_entities[i].id == id)
        {
            beginRemoveRows(QModelIndex(), i, i);
            m_entities.removeAt(i);
            endRemoveRows();
            break;
        }
    }
}



void EntityModel::clearEntities()
{
    beginResetModel();
    m_entities.clear();
    endResetModel();
}


QGeoCoordinate EntityModel::calculateNewPosition(const QGeoCoordinate& position, double heading_deg, double speed_kts, double deltaTime_ms)
{
    // Something wrong in here!


    constexpr double earthRadius_m { 6371000 };
    constexpr double knots_to_metres_per_second { 0.514444 };

    double latRad = position.latitude() * std::numbers::pi / 180.0;
    double lonRad = position.longitude() * std::numbers::pi / 180.0;


    double headingRad = heading_deg * std::numbers::pi / 180.0;

    double speedMPS = speed_kts * knots_to_metres_per_second;

    double distance = speedMPS * deltaTime_ms/1000.0;

    double distanceRad = distance / earthRadius_m;

    double newLatRad = asin (sin(latRad) * cos(distanceRad) +
                            cos(latRad) * sin(distanceRad) * cos(headingRad));

    double newLonRad = lonRad + atan2(sin(headingRad) * sin(distanceRad) * cos(latRad),
                                      cos(distanceRad) - sin(latRad) * sin(newLatRad));

    double newLat = newLatRad * 180 / std::numbers::pi;
    double newLon = newLonRad * 180 / std::numbers::pi;

    return QGeoCoordinate( newLat, newLon );

}



