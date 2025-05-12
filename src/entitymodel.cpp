#include "entitymodel.h"


EntityModel::EntityModel(QObject *parent, double updateRateMS)
    : QAbstractListModel{parent},
    updateRateMilliseconds (updateRateMS)
{
    this->timer = new QTimer(this);

    QObject::connect(this->timer, &QTimer::timeout, this, &EntityModel::updateEntities);

    timer->start(updateRateMilliseconds);

}


void EntityModel::updateEntities()
{
    for (int i = 0; i < m_entities.size(); i++)
    {
        auto& entity = m_entities[i];

        auto newPosition = EntityUtils::calculateNewPosition(entity.latitude_deg,
                                                             entity.longitude_deg,
                                                             entity.heading_deg,
                                                             entity.speed_kts,
                                                             this->updateRateMilliseconds);

        entity.latitude_deg = std::get<0>(newPosition);
        entity.longitude_deg = std::get<1>(newPosition);

        QModelIndex index = createIndex(i, 0);
        emit dataChanged(index, index, { LatitudeRole, LongitudeRole });
    }
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

    const EntityUtils::Entity &entity = m_entities[index.row()];

    switch (role) {
    case IdRole:
        return entity.id;
    case NameRole:
        return entity.name;
    case LatitudeRole:
        return entity.latitude_deg;
    case LongitudeRole:
        return entity.longitude_deg;
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

    EntityUtils::Entity entity;
    entity.id = id;
    entity.name = name;
    entity.latitude_deg = latitude;
    entity.longitude_deg = longitude;
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

QVariantMap EntityModel::get(int row) const
{
    if (row < 0 || row >= m_entities.size())
        return QVariantMap();

    const EntityUtils::Entity &entity = m_entities[row];
    QVariantMap map;
    map["entityId"] = entity.id;
    map["name"] = entity.name;
    map["latitude"] = entity.latitude_deg;
    map["longitude"] = entity.longitude_deg;
    map["type"] = entity.type;
    map["heading"] = entity.heading_deg;
    map["speed"] = entity.speed_kts;
    return map;
}



void EntityModel::clearEntities()
{
    beginResetModel();
    m_entities.clear();
    endResetModel();
}


bool EntityModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid() || index.row() >= m_entities.size())
        return false;

    EntityUtils::Entity &entity = m_entities[index.row()];
    bool changed = false;

    switch (role) {
    case IdRole:
        if (value.toString() != entity.id) {
            entity.id = value.toString();
            changed = true;
        }
        break;
    case NameRole:
        if (value.toString() != entity.name) {
            entity.name = value.toString();
            changed = true;
        }
        break;
    case LatitudeRole:
        if (value.toDouble() != entity.latitude_deg) {
            entity.latitude_deg = value.toDouble();
            changed = true;
        }
        break;
    case LongitudeRole:
        if (value.toDouble() != entity.longitude_deg) {
            entity.longitude_deg = value.toDouble();
            changed = true;
        }
        break;
    case TypeRole:
        if (value.toString() != entity.type) {
            entity.type = value.toString();
            changed = true;
        }
        break;
    case HeadingRole:
        if (value.toDouble() != entity.heading_deg) {
            entity.heading_deg = value.toDouble();
            changed = true;
        }
        break;
    case SpeedRole:
        if (value.toDouble() != entity.speed_kts) {
            entity.speed_kts = value.toDouble();
            changed = true;
        }
        break;
    default:
        return false;
    }

    if (changed) {
        emit dataChanged(index, index);
        return true;
    }

    return false;
}

Qt::ItemFlags EntityModel::flags(const QModelIndex& index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}



