#include "ownshipmodel.h"
#include "entityutils.h"

OwnshipModel::OwnshipModel(double latitude_deg, double longitude_deg, double heading_deg, double speed_kts, double updateRateMS, QObject *parent)
    : m_latitude_deg { latitude_deg },
      m_longitude_deg { longitude_deg },
      m_heading_deg { heading_deg },
      m_speed_kts { speed_kts },
      m_updateRateMilliseconds { updateRateMS },
      QObject{parent}
{
    this->timer = std::make_unique<QTimer>();

    QObject::connect(this->timer.get(), &QTimer::timeout, this, &OwnshipModel::updateData);

    timer->start(this->m_updateRateMilliseconds);
}


void OwnshipModel::updateData()
{
    auto newPosition = EntityUtils::calculateNewPosition(m_latitude_deg,
                                                         m_longitude_deg,
                                                         m_heading_deg,
                                                         m_speed_kts,
                                                         m_updateRateMilliseconds);

    m_latitude_deg = std::get<0>(newPosition);
    m_longitude_deg = std::get<1>(newPosition);                                                    

    emit latitude_degChanged();
    emit longitude_degChanged();
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


double OwnshipModel::latitude_deg() const
{
    return m_latitude_deg;
}

void OwnshipModel::setLatitude_deg(double newLatitude_deg)
{
    if (qFuzzyCompare(m_latitude_deg, newLatitude_deg))
        return;
    m_latitude_deg = newLatitude_deg;
    emit latitude_degChanged();
}

double OwnshipModel::longitude_deg() const
{
    return m_longitude_deg;
}

void OwnshipModel::setLongitude_deg(double newLongitude_deg)
{
    if (qFuzzyCompare(m_longitude_deg, newLongitude_deg))
        return;
    m_longitude_deg = newLongitude_deg;
    emit longitude_degChanged();
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














