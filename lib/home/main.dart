import 'dart:convert';
import 'dart:developer';
import 'package:aayu_mobile/home/emergency.dart';
import 'package:aayu_mobile/locationservice_state.dart';
import 'package:aayu_mobile/map_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MainP extends StatefulWidget {
  @override
  _MainPState createState() => _MainPState();
}

class _MainPState extends State<MainP> with TickerProviderStateMixin {
  List hospitals = [];
  final GoMap mapfnx = GoMap();
  List markers = [];
  // void _onMapCreated(GoogleMapController controller) async {
  //   _mapController = controller;
  //   _setMapStyle();
  //   QuerySnapshot snapshot =
  //       await Firestore.instance.collection('hospital').getDocuments();
  //   for (int i = 0; i < snapshot.documents.length; i++) {
  //     var hospitaldata = snapshot.documents[i].data;
  //     String name = hospitaldata['name'];
  //     var addresses = await Geocoder.local.findAddressesFromQuery(name);
  //     var location = addresses.first.coordinates;
  //     markers.add(Marker(
  //         onTap: () {
  //           showDialog(
  //               context: context,
  //               builder: (ctxt) =>
  //                   AlertDialog(title: Text("Dhulikhel Hospital")));
  //         },
  //         markerId: MarkerId("01"),
  //         position:
  //             LatLng(currentPosition!.latitude, currentPosition!.longitude),
  //         infoWindow: InfoWindow(
  //             title: "Dhulikhel Hospital", snippet: "Dhulikhel, Kavre")));
  //   }
  //   setState(() {});
  // }

  String searchAddr = "";
  bool loading = false;

  getallhospitals() async {
    final response = await http.get(
      Uri.parse('http://128.199.21.216:9191/api/hospital/list'),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var serverResponse = response.body;
      hospitals = jsonDecode(serverResponse);
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
    getHospitalCorrdinate();
  }

  getHospitalCorrdinate() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    List newData = [];
    await Future.delayed(Duration(milliseconds: 1000));
    log(hospitals.length.toString());
    for (int i = 0; i < hospitals.length; i++) {
      try {
        final query = hospitals[i]["hospital_name"];
        var data = await GeocoderBuddy.query(query);
        if (data.isNotEmpty) {
          log(hospitals[i]["hospital_name"] + "--> done");
          double lat = double.parse(data[0].lat);
          double lon = double.parse(data[0].lon);
          markers.add({
            "location": LatLng(lat, lon),
            "name": hospitals[i]["hospital_name"]
          });
          setState(() {});
          double dist = Geolocator.distanceBetween(
              currentPosition.latitude!, currentPosition.longitude!, lat, lon);
          newData.add([hospitals[i], dist]);
        }
      } catch (e) {
        print("error-->" + e.toString());
        hospitals[i] = [hospitals[i], 3000.00];
      }
    }
    hospitals = newData;
    log(markers.toString());
    sortHospital();
  }

  sortHospital() {
    int high = hospitals.length - 1;
    int low = 0;
    hospitals = quickSort(hospitals, low, high);
  }

  List quickSort(List list, int low, int high) {
    if (low < high) {
      int pi = partition(list, low, high);
      quickSort(list, low, pi - 1);
      quickSort(list, pi + 1, high);
    }
    return list;
  }

  int partition(List list, low, high) {
    if (list.isEmpty) {
      return 0;
    }
    double pivot = list[high][1];
    int i = low - 1;
    for (int j = low; j < high; j++) {
      if (list[j][1] < pivot) {
        i++;
        swap(list, i, j);
      }
    }
    swap(list, i + 1, high);
    return i + 1;
  }

  void swap(List list, int i, int j) {
    List temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  @override
  void initState() {
    super.initState();
    getallhospitals();
  }

  @override
  Widget build(BuildContext context) {
    //find the current user
    //final user = Provider.of<User>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.lightBlue, width: 0.5))),
                child: Image.asset("assets/aayu16.png")),
            actions: [
              // ignore: deprecated_member_use
              TextButton.icon(
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, "Welcome");
                    //if user is not null signout or else pop and go to welcome screen
                    //if (user == null) {
                    //Navigator.popAndPushNamed(context, "Welcome");
                    //} else
                    //await _auth.signOut();
                  },
                  icon: Icon(Icons.person, color: Colors.lightBlue, size: 30),
                  label: Text('logout',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 16)))
            ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctxt) => AlertDialog(
                        title: Text("Emergency"),
                        titleTextStyle:
                            TextStyle(fontSize: 32, color: Colors.black),
                        titlePadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        content: Emergencyform(hospital: hospitals),
                      ));
              setState(() {});
            },
            child: Icon(Icons.add, color: Colors.lightBlue, size: 30),
            backgroundColor: Colors.white,
            elevation: 5,
            hoverColor: Colors.grey[200],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Stack(children: [
          GetBuilder<LocationServiceController>(
              init: locationServiceController,
              builder: (val) {
                return Container(
                  child: FlutterMap(
                    mapController: mapfnx.mapController,
                    options: MapOptions(
                      center: LatLng(val.locationData.latitude,
                          val.locationData.longitude),
                      zoom: 16,
                    ),
                    layers: [
                      TileLayerOptions(
                        tms: true,
                        urlTemplate:
                            "http://map.gallimap.com/geoserver/gwc/service/tms/1.0.0/GalliMaps%3AGalliMaps@EPSG%3A3857@png/{z}/{x}/{y}.png?authkey=530f1b81-d4f6-4c1f-88a0-c149d350c046",
                      ),
                      PolylineLayerOptions(
                        polylines: [
                          Polyline(
                              points: val.points,
                              strokeWidth: 5,
                              color: Colors.red)
                        ],
                      ),
                      MarkerLayerOptions(
                        markers: [
                          for (int i = 0; i < markers.length; i++)
                            Marker(
                                point: LatLng(markers[i]["location"].latitude,
                                    markers[i]["location"].longitude),
                                builder: ((context) => Container(
                                      color: Colors.red,
                                      width: 54,
                                      height: 54,
                                      child: Center(
                                          child: Text(
                                        markers[i]["name"],
                                        style: TextStyle(fontSize: 12),
                                      )),
                                    ))),
                          Marker(
                              point: LatLng(27.7026, 85.2825),
                              builder: ((context) => Container(
                                    width: 20,
                                    height: 20,
                                    child: Card(
                                      color: Colors.blue,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.white, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  )))
                        ],
                      ),
                    ],
                    nonRotatedChildren: [
                      Positioned(
                          bottom: -64,
                          right: 0,
                          child: GestureDetector(
                              onTap: () {
                                mapfnx.animatedMapMove(
                                    LatLng(val.locationData.latitude,
                                        val.locationData.longitude),
                                    16,
                                    this,
                                    mounted);
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                color: Colors.red,
                              )))
                    ],
                  ),
                );
              }),
          loading
              ? Center(
                  child: Container(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.lightBlue))))
              : Container(),
          Positioned(
              top: 20,
              left: 4,
              right: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width - 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightBlue),
                          child: TextField(
                            maxLines: 1,
                            cursorColor: Colors.white,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Colors.white,
                                letterSpacing: 2),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                              hintText: "Enter Address",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: Colors.white,
                                  letterSpacing: 2),
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              setState(() {
                                searchAddr = val;
                              });
                            },
                            onEditingComplete: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                            icon: Icon(Icons.search,
                                size: 30, color: Colors.lightBlue),
                            onPressed: () async {
                              FocusManager.instance.primaryFocus!.unfocus();
                              setState(() {
                                loading = true;
                              });
                              // var addresses = await Geocoder.local
                              //     .findAddressesFromQuery(searchAddr);
                              // var first = addresses.first.coordinates;
                              // _mapController.animateCamera(
                              //     CameraUpdate.newCameraPosition(CameraPosition(
                              //         target: LatLng(
                              //             first.latitude, first.longitude),
                              // zoom: 15.5)));
                              setState(() {
                                loading = false;
                              });
                            }),
                      ),
                    ]),
              )),
          Positioned(
              bottom: 40,
              height: 60,
              width: 60,
              left: MediaQuery.of(context).size.width * 0.45,
              child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Icon(
                      Icons.my_location,
                      color: Colors.lightBlue,
                      size: 40,
                    ),
                  ),
                  onTap: () async {
                    mapfnx.animatedMapMove(
                        LatLng(locationServiceController.locationData.latitude,
                            locationServiceController.locationData.longitude),
                        16,
                        this,
                        mounted);
                  }))
        ]));
  }
}
