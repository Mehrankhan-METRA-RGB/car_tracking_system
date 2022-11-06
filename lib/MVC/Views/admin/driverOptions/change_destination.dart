import 'package:car_tracking_system/Constants/values.dart';
import 'package:car_tracking_system/Constants/widgets/widgets.dart';
import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Models/driver_model.dart';
import 'package:car_tracking_system/MVC/Models/instructions_model.dart';
import 'package:car_tracking_system/MVC/Views/maps/map_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Models/Collections.dart';
import '../../../Models/company_model.dart';

class ChangeDestination extends StatefulWidget {
  const ChangeDestination({this.driver, this.comp, Key? key}) : super(key: key);
  final Driver? driver;
  final Company? comp;

  @override
  State<ChangeDestination> createState() => _ChangeDestinationState();
}

class _ChangeDestinationState extends State<ChangeDestination> {
  LatLng? destinationPositions;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    // TODO: implement initState
    destinationPositions = listToLatLng(widget.driver!.destinationPoints!);
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Text(
              'Destinations',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
          Expanded(
              child: MapWidget(
            initialCamera:
                CameraPosition(target: destinationPositions!, zoom: 12),
            marker: Marker(
              markerId: const MarkerId('destinationMark'),
              position: destinationPositions!,
              icon: destinationIcon,
            ),
            getPositions: (clickPosition) {
              setState(() {
                destinationPositions = clickPosition;
              });
            },
          )),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () => _onSubmit(context, destinationPositions!,
                        compId: widget.comp!.id, driverId: widget.driver!.id),
                    child: Text(
                      'Submit',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  void setCustomMarkerIcon() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/icons/destination.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );

    setState(() {});
  }

  void _onSubmit(BuildContext context, LatLng points,
      {compId, driverId}) async {
    await FirebaseFirestore.instance
        .collection(Collection.company)
        .doc(compId)
        .collection(Collection.drivers)
        .doc(driverId)
        .update({'destinationPoints': latLngToList(points)});
    await CompanyController.instance.sendInstructions(
        Instruction(
            message:
                'Vendor Change your Destination Points to Latitude: ${points.latitude} and Longitude: ${points.longitude}',
            dateTime: DateTime.now().toString(),
            fromAdmin: true),
        compId: widget.comp?.id,
        driverId: widget.driver?.id);
    Navigator.pop(context);
    App.instance.snackBar(context,
        text: 'Destination points Updated!!!', bgColor: Colors.green);
  }
}
