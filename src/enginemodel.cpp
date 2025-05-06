#include "enginemodel.h"

EngineModel::EngineModel(QObject* parent)
		: QAbstractListModel {parent}
{
}

int EngineModel::rowCount(const QModelIndex& parent) const
{
	if (parent.isValid())
		return 0;

	return m_engines.count();
}

QVariant EngineModel::data(const QModelIndex& index, int role) const
{
	if (!index.isValid() || index.row() >= m_engines.size())
		return QVariant();

	const auto& engine = m_engines[index.row()];

	switch (role)
	{
		case NameRole:
			return engine.name;
		case Rpm_percentRole:
			return engine.rpm_percent;
		default:
			return QVariant();
	}
}

bool EngineModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
	if (!index.isValid() || index.row() >= m_engines.size())
		return false;

	auto& engine = m_engines[index.row()];
	bool changed = false;

	switch (role)
	{
	case NameRole:
		if (value.toString() != engine.name)
		{
			engine.name = value.toString();
			changed = true;
		}
		break;

	case Rpm_percentRole:
		if (value.toInt() != engine.rpm_percent)
		{
			engine.rpm_percent = value.toInt();
			changed = true;
		}
		break;

	default:
		return false;
	}

	if (changed)
	{
		emit dataChanged(index, index);
		return true;
	}

	return false;

}

QHash<int, QByteArray> EngineModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[NameRole] = "name";
	roles[Rpm_percentRole] = "rpm_percent";

	return roles;
}

Qt::ItemFlags EngineModel::flags(const QModelIndex& index) const
{
	if (!index.isValid())
		return Qt::NoItemFlags;

	return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

void EngineModel::add(const QString& name,
                      int rpm_percent)
{
	beginInsertRows(QModelIndex(), m_engines.size(), m_engines.size());

	engine_t engine;

	engine.name = name;
	engine.rpm_percent = rpm_percent;
	m_engines.append(engine);

	endInsertRows();
}

QVariantMap EngineModel::getByIndex(int row) const
{
	if (row < 0 || row >= m_engines.size())
		return QVariantMap();

	const auto& engine = m_engines[row];

	QVariantMap map;

	map["name"] = engine.name;
	map["rpm_percent"] = engine.rpm_percent;

	return map;
}

QVariantMap EngineModel::getByName(const QString& name) const
{
	for (const auto& engine: m_engines)
	{
		if (engine.name == name)
		{
			QVariantMap map;

			map["name"] = engine.name;
			map["rpm_percent"] = engine.rpm_percent;

			return map;
		}
	}

	return QVariantMap();
}
