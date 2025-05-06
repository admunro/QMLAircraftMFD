#pragma once

#include <QAbstractListModel>

class EngineModel : public QAbstractListModel
{
    Q_OBJECT

public:

    struct engine_t
    {
        QString name;
        int rpm_percent { 0 };
    };

    enum EngineModelRoles
    {
        NameRole = Qt::UserRole + 1,
        Rpm_percentRole
    };

    Q_ENUMS(EngineModelRoles);

    explicit EngineModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;

    Q_INVOKABLE void add(const QString& name,
                         int rpm_percent);

    Q_INVOKABLE QVariantMap getByIndex(int row) const;
    Q_INVOKABLE QVariantMap getByName(const QString& name) const;


private:

    QVector<engine_t> m_engines;

};
