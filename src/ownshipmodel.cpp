#include "ownshipmodel.h"

OwnshipModel::OwnshipModel(QObject *parent, double updateRateMS)
    : QAbstractListModel{parent},
    updateRateMilliseconds (updateRateMS)
{
    this->timer = new QTimer();

    QObject::connect(this->timer, &QTimer::timeout, this, &OwnshipModel::updateData);

    timer->start(this->updateRateMilliseconds);

}


void OwnshipModel::updateData()
{
    auto newPosition = EntityUtils::calculateNewPosition(ownship.position,
                                                         ownship.heading_deg,
                                                         ownship.speed_kts,
                                                         updateRateMilliseconds);


    QModelIndex index = createIndex(0, 0);

    emit dataChanged(index, index, { LatitudeRole, LongitudeRole });

}


int OwnshipModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return 1;
}


QVariant OwnshipModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= 1)
        return QVariant();

    switch (role) {
    case IdRole:
        return ownship.id;
    case NameRole:
        return ownship.name;
    case LatitudeRole:
        return ownship.position.latitude();
    case LongitudeRole:
        return ownship.position.longitude();
    case TypeRole:
        return ownship.type;
    case HeadingRole:
        return ownship.heading_deg;
    case SpeedRole:
        return ownship.speed_kts;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> OwnshipModel::roleNames() const
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


void OwnshipModel::addOwnship(const QString& id,
                              const QString& name,
                              double latitude,
                              double longitude,
                              const QString& type,
                              double speed_kts,
                              double heading_deg)
{
    beginInsertRows(QModelIndex(), 0, 0); // There should only ever be one ownship.

    ownship.id = id;
    ownship.name = name;
    ownship.position = QGeoCoordinate(latitude, longitude);
    ownship.type = type;
    ownship.heading_deg = heading_deg;
    ownship.speed_kts = speed_kts;

    endInsertRows();
}


bool OwnshipModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid() || index.row() >= 1)
        return false;

    bool changed = false;

    switch (role) {
    case IdRole:
        if (value.toString() != ownship.id) {
            ownship.id = value.toString();
            changed = true;
        }
        break;
    case NameRole:
        if (value.toString() != ownship.name) {
            ownship.name = value.toString();
            changed = true;
        }
        break;
    case LatitudeRole:
        if (value.toDouble() != ownship.position.latitude()) {
            ownship.position.setLatitude(value.toDouble());
            changed = true;
        }
        break;
    case LongitudeRole:
        if (value.toDouble() != ownship.position.longitude()) {
            ownship.position.setLongitude(value.toDouble());
            changed = true;
        }
        break;
    case TypeRole:
        if (value.toString() != ownship.type) {
            ownship.type = value.toString();
            changed = true;
        }
        break;
    case HeadingRole:
        if (value.toDouble() != ownship.heading_deg) {
            ownship.heading_deg = value.toDouble();
            changed = true;
        }
        break;
    case SpeedRole:
        if (value.toDouble() != ownship.speed_kts) {
            ownship.speed_kts = value.toDouble();
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

Qt::ItemFlags OwnshipModel::flags(const QModelIndex& index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

QVariantMap OwnshipModel::get(int row) const
{
    if (row != 0)
        return QVariantMap();

    QVariantMap map;
    map["entityId"] = ownship.id;
    map["name"] = ownship.name;
    map["latitude"] = ownship.position.latitude();
    map["longitude"] = ownship.position.longitude();
    map["type"] = ownship.type;
    map["heading"] = ownship.heading_deg;
    map["speed"] = ownship.speed_kts;
    return map;
}

