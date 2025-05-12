#pragma once

#include <tuple>
#include <QString>
namespace EntityUtils
{
    struct Entity
    {
        QString id { "" };
        QString name { "" };
        double latitude_deg { 0.0 };
        double longitude_deg { 0.0 };
        QString type { "" };

        double heading_deg { 0.0 };
        double speed_kts { 0.0 };
    };


    std::tuple<double, double> calculateNewPosition(double latitude_deg,
                                                    double longitude_deg,
                                                    double heading_deg,
                                                    double speed_kts,
                                                    double deltaTime_ms);

}
