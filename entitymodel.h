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

    const Entity& getItem(int row) const {
        return m_entities[row];
    }

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



class EntityToTableModel: public QAbstractTableModel
{
public:
    EntityToTableModel(EntityModel* entityModel, QObject* parent = nullptr)
        : QAbstractTableModel(parent), m_entityModel(entityModel) {

        m_columnNames << "Name" << "Value" << "Type" << "Category";
    }


    int rowCount(const QModelIndex& parent = QModelIndex()) const override {
        Q_UNUSED(parent);
        return m_entityModel->rowCount();
    }

    int columnCount(const QModelIndex& parent = QModelIndex()) const override {
        Q_UNUSED(parent);
        return m_entityModel->roleNames().size();
    }

    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override {
        if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
            return m_columnNames.at(section);
        }
        return QAbstractTableModel::headerData(section, orientation, role);
    }

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override {
        if (!index.isValid())
            return QVariant();

        if (role == Qt::DisplayRole || role == Qt::EditRole) {
            const EntityModel::Entity& item = m_entityModel->getItem(index.row());

            // Return the appropriate property based on column
            switch (index.column()) {
            case 0: return item.id;
            case 1: return item.name;
            case 2: return item.position.latitude();
            case 3: return item.position.longitude();
            case 4: return item.type;
            case 5: return item.speed_kts;
            case 6: return item.heading_deg;
            default: return QVariant();
            }
        }
        return QVariant();
    }

private:
    EntityModel* m_entityModel;
    QStringList m_columnNames;
};
