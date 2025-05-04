#pragma once

#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>

class FuelTankModel : public QAbstractListModel
{
	Q_OBJECT
	QML_ELEMENT

public:

	struct fueltank_t
	{
		QString name;
		int capacity_kg { 0 };
		int fill_level_kg { 0 };
	};

	enum FuelTankModelRoles
	{
		NameRole = Qt::UserRole + 1,
		Capacity_kgRole,
		Fill_level_kgRole
	};

	Q_ENUM(FuelTankModelRoles);

	explicit FuelTankModel(QObject* parent = nullptr);

	int rowCount(const QModelIndex& parent = QModelIndex()) const override;
	QVariant data(const QModelIndex& index, int role) const override;
	bool setData(const QModelIndex& index, const QVariant& value, int role) override;
	QHash<int, QByteArray> roleNames() const override;
	Qt::ItemFlags flags(const QModelIndex& index) const override;

	Q_INVOKABLE void add(const QString& name,
	                     int capacity_kg,
	                     int fill_level_kg);

	Q_INVOKABLE QVariantMap getByIndex(int row) const;
	Q_INVOKABLE QVariantMap getByName(const QString& name) const;


private:

	QVector<fueltank_t> m_fueltanks;

};
