#pragma once

#include <QObject>
#include <QGeoCoordinate>
#include <QTimer>
#include <QtQml/qqmlregistration.h>



class OwnshipModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    //QML_UNCREATABLE("OwnshipModel is created in C++ and should not be created directly in QML")

public:

    explicit OwnshipModel(QGeoCoordinate startPosition = QGeoCoordinate(0.0, 0.0),
                          double heading_deg = 0.0,
                          double speed_kts = 0.0 ,
                          double updateRateMS = 0.0,
                          QObject *parent = nullptr);

    void updateData();

    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged FINAL)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(QGeoCoordinate position READ position WRITE setPosition NOTIFY positionChanged FINAL)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged FINAL)
    Q_PROPERTY(double heading_deg READ heading_deg WRITE setHeading_deg NOTIFY heading_degChanged FINAL)
    Q_PROPERTY(double speed_kts READ speed_kts WRITE setSpeed_kts NOTIFY speed_ktsChanged FINAL)

    QString id() const;
    void setId(const QString &newId);

    QString name() const;
    void setName(const QString &newName);

    QGeoCoordinate position() const;
    void setPosition(const QGeoCoordinate &newPosition);

    QString type() const;
    void setType(const QString &newType);

    double heading_deg() const;
    void setHeading_deg(double newHeading_deg);

    double speed_kts() const;
    void setSpeed_kts(double newSpeed_kts);

signals:

    void idChanged();
    void nameChanged();
    void positionChanged();
    void typeChanged();
    void heading_degChanged();
    void speed_ktsChanged();

private:


    QTimer* timer;
    double m_updateRateMilliseconds;

    QString m_id;
    QString m_name;
    QGeoCoordinate m_position;
    QString m_type;

    double m_heading_deg { 0.0 };
    double m_speed_kts { 0.0 };

};

