#pragma once

#include <QGeoCoordinate>

namespace EntityUtils
{
    struct Entity
    {
        QString id { "" };
        QString name { "" };
        QGeoCoordinate position;
        QString type { "" };

        double heading_deg { 0.0 };
        double speed_kts { 0.0 };
    };


    QGeoCoordinate calculateNewPosition(const QGeoCoordinate& position,
                                        double heading_deg,
                                        double speed_kts,
                                        double deltaTime_ms);

}
