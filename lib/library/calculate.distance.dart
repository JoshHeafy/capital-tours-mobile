import 'dart:math';

class LocationUtils {
  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusMeters = 6371000;

    double lat1Rad = degreesToRadians(lat1);
    double lon1Rad = degreesToRadians(lon1);
    double lat2Rad = degreesToRadians(lat2);
    double lon2Rad = degreesToRadians(lon2);

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distanceMeters = earthRadiusMeters * c;

    return distanceMeters;
  }

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
