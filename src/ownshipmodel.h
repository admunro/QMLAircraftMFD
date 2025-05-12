#pragma once

#include <QObject>
#include <QTimer>

#include <memory>


class OwnshipModel : public QObject
{
    Q_OBJECT

public:

    explicit OwnshipModel(double latitude_deg = 0.0,
                          double longitude_deg = 0.0,
                          double heading_deg = 0.0,
                          double speed_kts = 0.0 ,
                          double updateRateMS = 0.0,
                          QObject *parent = nullptr);

    void updateData();

    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged FINAL)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(double latitude_deg READ latitude_deg WRITE setLatitude_deg NOTIFY latitude_degChanged FINAL)    
    Q_PROPERTY(double longitude_deg READ longitude_deg WRITE setLongitude_deg NOTIFY longitude_degChanged FINAL)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged FINAL)
    Q_PROPERTY(double heading_deg READ heading_deg WRITE setHeading_deg NOTIFY heading_degChanged FINAL)
    Q_PROPERTY(double speed_kts READ speed_kts WRITE setSpeed_kts NOTIFY speed_ktsChanged FINAL)

    QString id() const;
    void setId(const QString &newId);

    QString name() const;
    void setName(const QString &newName);

    double latitude_deg() const;
    void setLatitude_deg(double newLatitude_deg);

    double longitude_deg() const;
    void setLongitude_deg(double newLongitude_deg);

    QString type() const;
    void setType(const QString &newType);

    double heading_deg() const;
    void setHeading_deg(double newHeading_deg);

    double speed_kts() const;
    void setSpeed_kts(double newSpeed_kts);

signals:

    void idChanged();
    void nameChanged();
    void latitude_degChanged();
    void longitude_degChanged();
    void typeChanged();
    void heading_degChanged();
    void speed_ktsChanged();

private:


    std::unique_ptr<QTimer> timer;
    double m_updateRateMilliseconds;

    QString m_id;
    QString m_name;
    double m_latitude_deg { 0.0 };
    double m_longitude_deg { 0.0 };
    QString m_type;

    double m_heading_deg { 0.0 };
    double m_speed_kts { 0.0 };

};

