#include "ownshipmodel.h"
#include "entityutils.h"

OwnshipModel::OwnshipModel(QGeoCoordinate position, double heading_deg, double speed_kts, double updateRateMS, QObject *parent)
    : m_position { position },
      m_heading_deg { heading_deg },
      m_speed_kts { speed_kts },
      m_updateRateMilliseconds { updateRateMS },
      QObject{parent}
{
    this->timer = new QTimer();

    QObject::connect(this->timer, &QTimer::timeout, this, &OwnshipModel::updateData);

    timer->start(this->m_updateRateMilliseconds);
}


void OwnshipModel::updateData()
{
    m_position = EntityUtils::calculateNewPosition(m_position,
                                                   m_heading_deg,
                                                   m_speed_kts,
                                                   m_updateRateMilliseconds);

    emit positionChanged();
}

QString OwnshipModel::id() const
{
    return m_id;
}

void OwnshipModel::setId(const QString &newId)
{
    if (m_id == newId)
        return;
    m_id = newId;
    emit idChanged();
}

QString OwnshipModel::name() const
{
    return m_name;
}

void OwnshipModel::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

QGeoCoordinate OwnshipModel::position() const
{
    return m_position;
}

void OwnshipModel::setPosition(const QGeoCoordinate &newPosition)
{
    if (m_position == newPosition)
        return;
    m_position = newPosition;
    emit positionChanged();
}

QString OwnshipModel::type() const
{
    return m_type;
}

void OwnshipModel::setType(const QString &newType)
{
    if (m_type == newType)
        return;
    m_type = newType;
    emit typeChanged();
}

double OwnshipModel::heading_deg() const
{
    return m_heading_deg;
}

void OwnshipModel::setHeading_deg(double newHeading_deg)
{
    if (qFuzzyCompare(m_heading_deg, newHeading_deg))
        return;
    m_heading_deg = newHeading_deg;
    emit heading_degChanged();
}

double OwnshipModel::speed_kts() const
{
    return m_speed_kts;
}

void OwnshipModel::setSpeed_kts(double newSpeed_kts)
{
    if (qFuzzyCompare(m_speed_kts, newSpeed_kts))
        return;
    m_speed_kts = newSpeed_kts;
    emit speed_ktsChanged();
}














