import 'package:car_tracking_system/Constants/values.dart';
import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Models/collections.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Models/company_model.dart';
import '../../maps/map_widget.dart';
import '../../partials/buttons.dart';
import 'login.dart';

class AfterRegistration extends StatefulWidget {
  const AfterRegistration({this.data, Key? key}) : super(key: key);
  final dynamic data;
  @override
  _AfterRegistrationState createState() => _AfterRegistrationState();
}

class _AfterRegistrationState extends State<AfterRegistration> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _company = widget.data;
  }

  Company? _company;
  LatLng positions = const LatLng(34.027380914453964, 71.51632871478796);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: MapWidget(
                getPositions: (a) {
                  setState(() {
                    print(a);
                    positions = a;
                  });
                },
                marker: Marker(
                  markerId: MarkerId('${_company?.name}_${getRandomString(5)}'),
                  position: positions,
                  infoWindow: InfoWindow(
                    title: _company?.name,
                    snippet: _company?.biography,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AppButton(
              child: const Text('Submit'),
              onPressed: () {
                CompanyController.instance
                    .add(context,
                        collection: Collection.company,
                        data: _company!.copyWith(
                            points: [positions.latitude, positions.longitude]))
                    .then((docRef) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginCompany()));
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
