import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:car_tracking_system/Constants/values.dart';
import 'package:car_tracking_system/Constants/widgets/widgets.dart';
import 'package:car_tracking_system/MVC/Controllers/Rider/RiderMap/rider_map_controller.dart';
import 'package:car_tracking_system/MVC/Controllers/driver_controller.dart';
import 'package:car_tracking_system/MVC/Models/Collections.dart';
import 'package:car_tracking_system/MVC/Models/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../Data/map_styles.dart';
import '../../Models/company_model.dart';
import 'bottom_bar.dart';
import 'chat_to_admin.dart';

class RiderLiveMaps extends StatefulWidget {
  const RiderLiveMaps({this.token, Key? key, this.isDynamicLink = false})
      : super(key: key);

  final String? token;
  final bool isDynamicLink;

  @override
  State<RiderLiveMaps> createState() => _RiderLiveMapsState();
}

class _RiderLiveMapsState extends State<RiderLiveMaps> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  LocationData? currentLocation;
  GoogleMapController? mapController;
  String? companyId = ' ';
  String? driverId = ' ';
  LatLng? destination;
  LatLng? source;
  bool firstLoadMap = true;
  void auth() {
    companyId = widget.token?.split('%')[0];
    driverId = widget.token?.split('%')[1];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth();
    // getMapStyles();
    setCustomMarkerIcon();
    context.read<RiderMapCubit>().getData();
    getCurrentLocation();
    getHomeAndDestination();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderMapCubit, RiderMapState>(
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is Loading) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return Scaffold(
            body: GoogleMap(
              myLocationEnabled: false,
              mapType: MapType.normal,
              buildingsEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLocation?.latitude ?? 33.98008258050432,
                    currentLocation?.longitude ?? 71.45246498286724),
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
                    position: source ??
                        const LatLng(33.98008258050432, 71.45246498286724)),
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
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 400,
                              ));
                        }),
                    icon: currentLocationIcon,
                    position: LatLng(
                        currentLocation?.latitude ?? 33.98024911531769,
                        currentLocation?.longitude ?? 71.4524532482028)),
                Marker(
                    markerId: const MarkerId(
                      'destination',
                    ),
                    icon: destinationIcon,
                    position: destination ??
                        const LatLng(33.98008258050432, 71.45246498286724)),
              },
              onTap: (dist) {
                // setState(() {
                log('LOCATION: ${dist.latitude}-${dist.longitude}');
                // markers[1].copyWith(positionParam:dist );
                // });
              },
            ),

            ///I will continue with bottom act ion bar
            floatingActionButton: widget.isDynamicLink
                ? null
                : BottomBar(
                    items: [
                      IconButton(
                          onPressed: () {
                            App.instance.dialog(context,
                                child: ChatToAdmin(
                                  companyId: companyId,
                                  driverId: driverId,
                                ));
                          },
                          color: Colors.green,
                          icon: const Icon(
                            Icons.message,
                            size: 25,
                          )),
                    ],
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            // FloatingActionButton(
            //   onPressed: () async {
            //     App.instance.dialog(context,
            //         child: ChatToAdmin(
            //           companyId: companyId,
            //           driverId: driverId,
            //         ));
            //   },
            //   child: const Icon(Icons.chat),
            // ),
          );
        }
      },
    );
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

    ///First Load to animate Camera
    googleMapController.animateCamera(CameraUpdate.newLatLng(
      LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      ),
    ));

    location.onLocationChanged.listen(
      (newLoc) async {
        await Future.delayed(const Duration(milliseconds: 1200), () {
          currentLocation = newLoc;
          DriverController.instance.updateCurrentLocation(
              companyId: companyId!,
              driverId: driverId!,
              data: latLngToList(LatLng(newLoc.latitude!, newLoc.longitude!)));
          googleMapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
            // newCameraPosition(
            //   CameraPosition(
            //     zoom: 14.4746,
            //     target: LatLng(
            //       newLoc.latitude!,
            //       newLoc.longitude!,
            //     ),
            //   ),
            // )
          );
          setState(() {});
          log('\nLat: ${newLoc.latitude} \nLong: ${newLoc.longitude}');
        });

        // setState(() {});
      },
    );
    // setState(() {});
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

  void getHomeAndDestination() async {
    var ref = FirebaseFirestore.instance
        .collection(Collection.company)
        .doc(companyId);
    ref.get().then((a) {
      Company comp = Company.fromJson(jsonEncode(a.data()));
      source = listToLatLng(comp.points!);
    });

    ref.collection(Collection.drivers).doc(driverId).get().then((driver) {
      Driver locDriver = Driver.fromJson(jsonEncode(driver.data()));
      destination = listToLatLng(locDriver.destinationPoints!);
    });
  }

  // List<LatLng> markers = [
  //   const LatLng(33.98077346153088, 71.45211059600115),
  //   const LatLng(33.98053519856771, 71.45275164395571)
  // ];
  // static  CameraPosition _kGooglePeshawar = CameraPosition(
  //   target: LatLng(currentLocation?.latitude??34.027380914453964, 71.51632871478796),
  //   zoom: 14.4746,
  // );
  // void getPolyPoints() async {
  //   //Global
  //   List<LatLng> polylineCoordinates = [];
  //
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   var poly = await polylinePoints.getRouteBetweenCoordinates(
  //       S.MAP_API_KEY, // Your Google Map Key
  //       PointLatLng(widget.source!.latitude, widget.source!.longitude),
  //       PointLatLng(
  //           widget.destination!.latitude, widget.destination!.longitude),
  //       avoidTolls: true,
  //       optimizeWaypoints: true);
  //   if (poly.points.isNotEmpty) {
  //     for (PointLatLng point in poly.points) {
  //       polylineCoordinates.add(
  //         LatLng(point.latitude, point.longitude),
  //       );
  //     }
  //     log('------------- POINTS NOT EMPTY ----------------');
  //
  //     // setState(() {print(polylineCoordinates);});
  //   } else {
  //     log('---------------\n---------------\n------------- POINTS EMPTY -------------------------------\n---------------\n');
  //   }
  // }
}
