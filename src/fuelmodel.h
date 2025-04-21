#pragma once

#include <QAbstractListModel>
#include <QQmlEngine>


class FuelModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT


public:

    struct fuelTank_t
    {
        QString tankName {};
        int capacity_kg {0};
        int fill_level_kg {0};
    };

    enum FuelRoles
    {
        fillLevelRole = Qt::UserRole + 1,
        capacityRole,
        nameRole
    };

    Q_ENUM(FuelRoles);

    explicit FuelModel(QObject* parent = nullptr);


    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;


    Q_INVOKABLE void addFuelTank(const QString& name, int capacity_kg, int fillLevel_kg);

    Q_INVOKABLE QVariantMap get(int row) const;

private:


    QVector<fuelTank_t> m_fuelTanks;

};
