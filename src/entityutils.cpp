#include <numbers>
#include <cmath>

#include "entityutils.h"

namespace EntityUtils
{

    QGeoCoordinate calculateNewPosition(const QGeoCoordinate& position,
                                        double heading_deg,
                                        double speed_kts,
                                        double deltaTime_ms)
    {
        constexpr double earthRadius_m { 6371000 };
        constexpr double knots_to_metres_per_second { 0.514444 };

        double latRad = position.latitude() * std::numbers::pi / 180.0;
        double lonRad = position.longitude() * std::numbers::pi / 180.0;


        double headingRad = heading_deg * std::numbers::pi / 180.0;

        double speedMPS = speed_kts * knots_to_metres_per_second;

        double distance = speedMPS * deltaTime_ms/1000.0;

        double distanceRad = distance / earthRadius_m;

        double newLatRad = asin (sin(latRad) * cos(distanceRad) +
                                cos(latRad) * sin(distanceRad) * cos(headingRad));

        double newLonRad = lonRad + atan2(sin(headingRad) * sin(distanceRad) * cos(latRad),
                                          cos(distanceRad) - sin(latRad) * sin(newLatRad));

        double newLat = newLatRad * 180 / std::numbers::pi;
        double newLon = newLonRad * 180 / std::numbers::pi;

        return QGeoCoordinate( newLat, newLon );
    }

}
