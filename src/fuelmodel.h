#pragma once

#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>


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
        FillLevelRole = Qt::UserRole + 1,  // Note - role names need to begin with a capital letter.
        CapacityRole,                      // see: https://stackoverflow.com/questions/66855134/how-to-access-a-q-enum-declared-in-c-class-from-qml
        NameRole
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
    Q_INVOKABLE QVariantMap get(const QString& name) const;

private:


    QVector<fuelTank_t> m_fuelTanks;

};
