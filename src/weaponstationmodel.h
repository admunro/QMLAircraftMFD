#pragma once

#include <QAbstractListModel>

class WeaponStationModel : public QAbstractListModel
{
	Q_OBJECT

public:

	struct weaponstation_t
	{
		QString name;
		QString weapon_type;
		QString weapon_category;
		bool selected { false };
		bool loaded { false };
	};

	enum WeaponStationModelRoles
	{
		NameRole = Qt::UserRole + 1,
		Weapon_typeRole,
		Weapon_categoryRole,
		SelectedRole,
		LoadedRole
	};

        Q_ENUMS(WeaponStationModelRoles);

	explicit WeaponStationModel(QObject* parent = nullptr);

	int rowCount(const QModelIndex& parent = QModelIndex()) const override;
	QVariant data(const QModelIndex& index, int role) const override;
    Q_INVOKABLE bool setData(const QModelIndex& index, const QVariant& value, int role) override;
	QHash<int, QByteArray> roleNames() const override;
	Qt::ItemFlags flags(const QModelIndex& index) const override;

	Q_INVOKABLE void add(const QString& name,
	                     const QString& weapon_type,
	                     const QString& weapon_category,
	                     bool selected = false,
	                     bool loaded = true);

	Q_INVOKABLE QVariantMap getByIndex(int row) const;
	Q_INVOKABLE QVariantMap getByName(const QString& name) const;


private:

	QVector<weaponstation_t> m_weaponstations;

};
