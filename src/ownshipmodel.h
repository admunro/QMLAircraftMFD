#pragma once

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QTimer>
#include <QtQml/qqmlregistration.h>

#include "entityutils.h"


class OwnshipModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:

    /* This is duplicated from EntityModel, find some way to make them both
     * use the same source...
     */
    enum OwnshipRoles
    {
        IdRole = Qt::UserRole + 1,
        NameRole,
        LatitudeRole,
        LongitudeRole,
        TypeRole,
        HeadingRole,
        SpeedRole
    };

    Q_ENUM(OwnshipRoles); // Expose this enum to QML

    explicit OwnshipModel(QObject *parent = nullptr, double updateRateMS = 0.0);

    void updateData();


    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;

    Q_INVOKABLE void addOwnship(const QString& id,
                                const QString& name,
                                double latitude,
                                double longidute,
                                const QString& type,
                                double speed_kts,
                                double heading_deg);

    Q_INVOKABLE QVariantMap get(int row) const;

private:


    QTimer* timer;
    double updateRateMilliseconds;

    EntityUtils::Entity ownship;

};

