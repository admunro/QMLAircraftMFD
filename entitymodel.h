#pragma once

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QVector>
#include <QTimer>





class EntityModel : public QAbstractListModel
{
    Q_OBJECT



public:

    struct Entity
    {
        QString id;
        QString name;
        QGeoCoordinate position;
        QString type;

        double heading_deg;
        double speed_kts;
    };



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


    void updateEntities();

    explicit EntityModel(QObject *parent = nullptr, double updateRateMS = 0.0);


    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addEntity(const QString& id,
                               const QString& name,
                               double latitude,
                               double longidute,
                               const QString& type,
                               double speed_kts,
                               double heading_deg);

    Q_INVOKABLE void removeEntity(const QString& id);

    Q_INVOKABLE void clearEntities();


private:

    QTimer* timer;

    double updateRateMilliseconds;

    QVector<Entity> m_entities;

    QGeoCoordinate calculateNewPosition(const QGeoCoordinate& position,
                                        double heading_deg,
                                        double speed_kts,
                                        double deltaTime_ms);


};
