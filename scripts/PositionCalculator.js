/**
 * Calculates a new position based on initial coordinates, speed, heading, and elapsed time.
 *
 * @param {number} lat - Initial latitude in decimal degrees
 * @param {number} lon - Initial longitude in decimal degrees
 * @param {number} speed - Speed in knots
 * @param {number} heading - Heading in degrees (0-360, where 0/360 is North, 90 is East, etc.)
 * @param {number} deltaTime - Elapsed time in seconds
 * @returns {object} - Object containing the new latitude and longitude
 */
function calculateNewPosition(lat, lon, speed, heading, deltaTime) {
  // Convert latitude and longitude from degrees to radians
  const latRad = lat * Math.PI / 180;
  const lonRad = lon * Math.PI / 180;

  // Convert heading from degrees to radians
  const headingRad = heading * Math.PI / 180;

  // Convert speed from knots to meters per second
  // 1 knot = 0.514444 meters per second
  const speedMPS = speed * 0.514444;

  // Calculate distance traveled in meters
  const distance = speedMPS * deltaTime;

  // Convert distance from meters to radians
  // Earth's radius is approximately 6371000 meters
  const earthRadius = 6371000;
  const distanceRad = distance / earthRadius;

  // Calculate new latitude and longitude in radians
  const newLatRad = Math.asin(
    Math.sin(latRad) * Math.cos(distanceRad) +
    Math.cos(latRad) * Math.sin(distanceRad) * Math.cos(headingRad)
  );

  const newLonRad = lonRad + Math.atan2(
    Math.sin(headingRad) * Math.sin(distanceRad) * Math.cos(latRad),
    Math.cos(distanceRad) - Math.sin(latRad) * Math.sin(newLatRad)
  );

  // Convert back to degrees
  const newLat = newLatRad * 180 / Math.PI;
  const newLon = newLonRad * 180 / Math.PI;

  return {
    latitude: newLat,
    longitude: newLon
  };
}

// Example usage:
// const initialLat = 37.7749; // San Francisco latitude
// const initialLon = -122.4194; // San Francisco longitude
// const speed = 10; // 10 knots
// const heading = 90; // East
// const deltaTime = 3600; // 1 hour in seconds
// const newPosition = calculateNewPosition(initialLat, initialLon, speed, heading, deltaTime);
// console.log(newPosition); // { latitude: 37.7749, longitude: -122.2846 } (approximate)
