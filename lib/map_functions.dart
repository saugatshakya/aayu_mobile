import 'dart:convert';
import 'dart:developer';

import 'package:aayu_mobile/locationservice_state.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:http/http.dart' as http;

class GoMap {
  final MapController mapController = MapController();
  locationStream() async {
    Geolocator.getPositionStream(
            locationSettings: LocationSettings(distanceFilter: 20))
        .listen((currentLocation) {
      if (locationServiceController.locationData.latitude !=
              currentLocation.latitude &&
          locationServiceController.locationData.longitude !=
              currentLocation.longitude) {
        locationServiceController.changeLocation(
            currentLocation.latitude, currentLocation.longitude);
      }
    });
  }

  void animatedMapMove(
      latlng.LatLng destLocation, double destZoom, vsync, mounted) async {
    if (!mounted) return;

    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: vsync);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.addListener(() {
      mapController.move(
          latlng.LatLng(
              _latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  setInitialLocation(vsync, mounted) async {
    Position _locationData = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    animatedMapMove(
        latlng.LatLng(_locationData.latitude, _locationData.longitude),
        16,
        vsync,
        mounted);
  }

  Future find(query) async {
    List suggestions = [];
    List finalsuggestions = [];
    final response = await http.get(
      Uri.parse("http://153.92.208.123:3000/searchApi/geojson/search/$query"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Referer': "gallimaps.com",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        String first = "";
        for (int j = 0; j < query.length; j++) {
          first = first + data[i]["name"][j];
        }
        if (query == first) {
          suggestions.add({"name": data[i]['name'], "type": "unknown"});
        }
      }
      var seen = <String>{};
      finalsuggestions =
          suggestions.where((element) => seen.add(element["name"])).toList();
      return finalsuggestions;
    } else {
      log(response.reasonPhrase!);
      return [];
    }
  }

  Future nearlocation(query) async {
    String lng = locationServiceController.locationData.longitude.toString();
    String lat = locationServiceController.locationData.latitude.toString();
    final response = await http.get(
      Uri.parse(
          "http://153.92.208.123:3000/searchApi/geojson/$query/$lng/$lat"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Referer': "gallimaps.com",
      },
    );
    log(response.body);
    if (response.statusCode == 200) {
      List suggestions = [];
      List finalsuggestions = [];
      var data = jsonDecode(response.body);
      List features = data["features"];

      for (int i = 0; i < features.length; i++) {
        String type = features[i]["geometry"]["type"];
        List location = features[i]["geometry"]["coordinates"];
        if (type == "Point") {
          suggestions.add({
            "id": query + "point",
            "name": query,
            "type": "point",
            "location": location
          });
        } else if (type == "MultiLineString") {
          suggestions.add({
            "id": query + "road",
            "name": query,
            "type": "road",
            "location": location
          });
        } else if (type == "MultiPolygon") {
          suggestions.add({
            "id": query + "area",
            "name": query,
            "type": "area",
            "location": location
          });
        }
      }
      var seen = <String>{};
      finalsuggestions =
          suggestions.where((element) => seen.add(element["id"])).toList();
      return finalsuggestions;
    } else {
      log("error---->" + response.reasonPhrase!);
    }
  }

  findBestRoute(List data) {
    int bestAtIndex = 0;
    double? bestdata;
    for (int i = 0; i < data.length; i++) {
      log(data[i]["distance"].toString());
      if (bestdata == null) {
        bestdata = data[i]["distance"] * 1.0;
        bestAtIndex = i;
      } else if (data[i]["distance"] < bestdata) {
        bestAtIndex = i;
      }
    }
    return bestAtIndex;
  }

  Future getRoute(
      String srclat, String srclng, String dstLat, String dstLng) async {
    List<latlng.LatLng> points = [];

    final response = await http.get(
      Uri.parse(
          "http://153.92.208.123:3000/routingAPI/driving?srcLat=$srclat&srcLng=$srclng&dstLat=$dstLat&dstLng=$dstLng"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Referer': "gallimaps.com",
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      int bestDistance = findBestRoute(data["data"]);
      List latlngs = data["data"][bestDistance]["latlngs"];
      if (latlngs.isNotEmpty) {
        for (int i = 0; i < latlngs.length; i++) {
          latlng.LatLng point =
              latlng.LatLng(latlngs[i][1] * 1.0, latlngs[i][0] * 1.0);
          points.add(point);
        }
      } else {
        Get.showSnackbar(const GetSnackBar(
          title: "Error",
          message: "No route found",
        ));
      }
    }

    return points;
  }
}
