#pragma once

#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>

class EnginesModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:

    struct engine_t
    {
        QString name;
        int rpm_percent { 0 };
    };

    enum EngineRoles
    {
        NameRole  = Qt::UserRole + 1,
        RPMPercentRole
    };

    Q_ENUM(EngineRoles);

    explicit EnginesModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;

    Q_INVOKABLE void addEngine(const QString& name, int rpm = 0);

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE QVariantMap get(const QString& name) const;


private:

    QVector<engine_t> m_engines;
};
