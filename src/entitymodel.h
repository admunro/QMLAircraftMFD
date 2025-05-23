#pragma once

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QVector>
#include <QTimer>
#include <QtQml/qqmlregistration.h>
#include "entityutils.h"

#include <memory>




class EntityModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT



public:

    enum EntityRoles
    {
        IdRole = Qt::UserRole + 1,
        NameRole,
        LatitudeRole,
        LongitudeRole,
        TypeRole,
        HeadingRole,
        SpeedRole
    };

    Q_ENUM(EntityRoles); // Expose this enum to QML


    void updateEntities();

    explicit EntityModel(QObject *parent = nullptr, double updateRateMS = 0.0);


    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;


    Q_INVOKABLE void addEntity(const QString& id,
                               const QString& name,
                               double latitude,
                               double longidute,
                               const QString& type,
                               double speed_kts,
                               double heading_deg);

    Q_INVOKABLE void removeEntity(const QString& id);

    Q_INVOKABLE void clearEntities();

    Q_INVOKABLE QVariantMap get(int row) const;


private:

    std::unique_ptr<QTimer> timer;

    double updateRateMilliseconds;

    QVector<EntityUtils::Entity> m_entities;

};

