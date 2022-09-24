import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapWidget extends StatefulWidget {
  const MapWidget({this.marker,this.getPositions,this.data,Key? key}) : super(key: key);
  final void Function(LatLng)? getPositions;
  final Marker? marker;
  final dynamic data;
  // Marker(
  // markerId: MarkerId(office.name),
  // position: LatLng(office.lat, office.lng),
  // infoWindow: InfoWindow(
  // title: office.name,
  // snippet: office.address,
  // ),
  // )
  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePeshawar = CameraPosition(
    target: LatLng(34.027380914453964, 71.51632871478796),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled:true,
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePeshawar,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: {widget.marker!},
      onTap:widget.getPositions,
    );

    //   Scaffold(
    //   body:
    //   // floatingActionButton: FloatingActionButton.extended(
    //   //   onPressed: _goToTheLake,
    //   //   label: const Text('To the lake!'),
    //   //   icon: const Icon(Icons.directions_boat),
    //   // ),
    // );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}