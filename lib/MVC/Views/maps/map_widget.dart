import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Data/map_styles.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {this.marker,
      this.height,
      this.margins,
      this.width,
      this.getPositions,
      this.initialCamera,
      Key? key})
      : super(key: key);
  final void Function(LatLng)? getPositions;
  final Marker? marker;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margins;
  final CameraPosition? initialCamera;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margins ?? EdgeInsets.zero,
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: GoogleMap(
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: widget.initialCamera ?? _kGooglePeshawar,
        onMapCreated: (GoogleMapController controller) async {
          controller.setMapStyle(mapStyles);
          _controller.complete(controller);
        },
        minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
        markers: {widget.marker!},
        onTap: widget.getPositions,
        gestureRecognizers: Set()
          ..add(
              Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
      ),
    );
  }
}
