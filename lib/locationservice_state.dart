import 'package:aayu_mobile/map_functions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationServiceController extends GetxController {
  LocationPermission locationAccess = LocationPermission.denied;
  bool locationStatus = false;
  String destinationAddress = "";
  LatLng locationData = LatLng(27.703598, 85.284283);
  var points = <LatLng>[];
  var driverLocation = [];

  changeAccess(val) {
    locationAccess = val;
    update();
  }

  changeStatus(val) {
    locationStatus = val;
    update();
  }

  changeLocation(lat, lng) {
    locationData = LatLng(lat, lng);
    update();
  }

  changedestination(val) {
    destinationAddress = val;
    update();
  }

  manualupdate() {
    update();
  }

  updateRoute(slat, slng, dlat, dlng) async {
    points = await GoMap().getRoute(
        slat.toString(), slng.toString(), dlat.toString(), dlng.toString());
    update();
  }

  clearRoute() {
    points = [];
    update();
  }

  updateDriverLocation(lat, lng, headingDir) {
    driverLocation = [
      [lat, lng, headingDir]
    ];
    update();
  }

  clearDriverLocation() {
    driverLocation = [];
    update();
  }
}

final LocationServiceController locationServiceController =
    Get.put(LocationServiceController());
