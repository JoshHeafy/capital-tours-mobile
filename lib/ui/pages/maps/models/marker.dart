import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? idLocation;
  final String? image;
  final String? driver;
  final int? numeroFlota;
  final LatLng? location;
  final String? numeroPlaca;

  MapMarker({
    required this.idLocation,
    required this.image,
    required this.driver,
    required this.numeroFlota,
    required this.location,
    required this.numeroPlaca,
  });
}
