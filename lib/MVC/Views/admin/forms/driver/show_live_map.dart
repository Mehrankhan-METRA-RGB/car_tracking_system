import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:car_tracking_system/Constants/values.dart';
import 'package:car_tracking_system/MVC/Controllers/driver_controller.dart';
import 'package:car_tracking_system/Constants/widgets/widgets.dart';
import 'package:car_tracking_system/MVC/Models/Collections.dart';
import 'package:car_tracking_system/MVC/Models/company_model.dart';
import 'package:car_tracking_system/MVC/Models/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../Data/map_styles.dart';
import '../../../../Models/Strings.dart';

class ShowLiveDriver extends StatefulWidget {
  const ShowLiveDriver(
      {required this.companyId, required this.driverId, Key? key})
      : super(key: key);
  final String? companyId;
  final String? driverId;

  @override
  State<ShowLiveDriver> createState() => _ShowLiveDriverState();
}

class _ShowLiveDriverState extends State<ShowLiveDriver> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  LocationData? currentLocation;
  GoogleMapController? mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getMapStyles();
    setCustomMarkerIcon();
    // getCurrentLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(Collection.company)
            .doc(widget.companyId)
            .snapshots(),
        builder: (context, companySnapshot) {
          if (companySnapshot.hasData) {
            print('company:${companySnapshot.data?.data()}');

            Company company = Company.fromJson(jsonEncode(companySnapshot.data?.data()));

            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(Collection.company)
                    .doc(widget.companyId)
                    .collection(Collection.drivers)
                    .doc(widget.driverId)
                    .snapshots(),
                builder: (context, driverSnapshot) {
                  if (driverSnapshot.hasData) {
                    print('Driver:${driverSnapshot.data?.data()}');

                    Driver driver = Driver.fromJson(jsonEncode(driverSnapshot.data?.data()));
                    return Scaffold(
                      body: GoogleMap(
                        myLocationEnabled: false,
                        mapType: MapType.normal,
                        buildingsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: listToLatLng(driver.permanentPoints!),
                          zoom: 14.4746,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                          _controller.complete(controller);
                          mapController?.setMapStyle(mapStyles);
                        },
                        // polylines: {
                        //   Polyline(
                        //     polylineId: PolylineId(getRandomString(10)),
                        //     points: polylineCoordinates,
                        //     color: const Color(0xFF7B61FF),
                        //     width: 6,
                        //   ),
                        // },
                        markers: {
                          Marker(
                              markerId: const MarkerId(
                                'source',
                              ),
                              icon: sourceIcon,
                              position:listToLatLng(company.points!)),
                          Marker(
                              markerId: const MarkerId(
                                'current',
                              ),
                              infoWindow: InfoWindow(
                                  title: 'Rider',
                                  snippet: 'Hello World',
                                  onTap: () {
                                    App.instance.dialog(context,
                                        child: Container(
                                          color: Colors.green,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: 400,
                                        ));
                                  }),
                              icon: currentLocationIcon,
                              position: listToLatLng(driver.permanentPoints!)),
                          Marker(
                              markerId: const MarkerId(
                                'destination',
                              ),
                              icon: destinationIcon,
                              position: listToLatLng(driver.destinationPoints!)),
                        },
                        onTap: (dist) {
                          // setState(() {
                          log('LOCATION: ${dist.latitude}-${dist.longitude}');
                          // markers[1].copyWith(positionParam:dist );
                          // });
                        },
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () async {
                          // getPolyPoints();
                        },
                        child: const Icon(Icons.directions),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void getCurrentLocation() async {
    Location location = Location();
    await location.enableBackgroundMode(enable: true);
    await location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) async {
        await Future.delayed(const Duration(milliseconds: 1200), () {
          currentLocation = newLoc;
          DriverController.instance.updateCurrentLocation(
              companyId: 't4lrHsrO9QwnbYHLD7G5',
              driverId: 'KJFigQR5TUMyIX4wfoHr',
              data: latLngToList(LatLng(newLoc.latitude!, newLoc.longitude!)));
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 14.4746,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
          log('${newLoc.latitude} === ${newLoc.longitude}');
        });

        // setState(() {});
      },
    );
    setState(() {});
  }

  void setCustomMarkerIcon() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/icons/home.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/icons/destination.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/icons/current.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
    // setState(() {});
  }

  // List<LatLng> markers = [
  //   const LatLng(33.98077346153088, 71.45211059600115),
  //   const LatLng(33.98053519856771, 71.45275164395571)
  // ];
  // static  CameraPosition _kGooglePeshawar = CameraPosition(
  //   target: LatLng(currentLocation?.latitude??34.027380914453964, 71.51632871478796),
  //   zoom: 14.4746,
  // );
  void getPolyPoints() async {
    //Global
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    var poly = await polylinePoints.getRouteBetweenCoordinates(
        S.MAP_API_KEY, // Your Google Map Key
        const PointLatLng(04975304, 94357),
        const PointLatLng(09485, 039475),
        avoidTolls: true,
        optimizeWaypoints: true);
    if (poly.points.isNotEmpty) {
      for (PointLatLng point in poly.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      log('------------- POINTS NOT EMPTY ----------------');

      // setState(() {print(polylineCoordinates);});
    } else {
      log('---------------\n---------------\n------------- POINTS EMPTY -------------------------------\n---------------\n');
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    mapController?.dispose();
    super.dispose();
  }
}
