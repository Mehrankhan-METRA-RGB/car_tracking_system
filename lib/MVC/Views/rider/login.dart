import 'package:car_tracking_system/MVC/Controllers/auth_controller.dart';
import 'package:car_tracking_system/MVC/Views/partials/text_field.dart';
import 'package:car_tracking_system/MVC/Views/rider/rider_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../partials/buttons.dart';

class LoginDriver extends StatefulWidget {
  const LoginDriver({Key? key}) : super(key: key);

  @override
  _LoginDriverState createState() => _LoginDriverState();
}

class _LoginDriverState extends State<LoginDriver> {
  final TextEditingController authentication =
      TextEditingController(text: 't4lrHsrO9QwnbYHLD7G5%Cracr0tjUI5gzTIWh03X');
  bool isLoading = false;
  LatLng positions = const LatLng(122.23232323, 35.343434344);
  final registrationFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);
  }

  getData(BuildContext context) async {
    await AuthController.instance.getDriverAuth().then((prefs) {
      if (prefs != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RiderLiveMaps(
                      auth: prefs,
                    )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        elevation: 0,
      ),
      body: Form(
        key: registrationFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: AppTextField(
                hint: 'Authentication',
                controller: authentication,
                onChange: (a) {},
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child:  AppButton(
                      child: const Text('Submit'),
                      onPressed: () async {

                        if (registrationFormKey.currentState!.validate()) {
                          await Future.delayed(
                              const Duration(
                                seconds: 2,
                              ), () {
                            AuthController.instance.driverLogin(
                              context,
                              authentication.text,
                            );
                          });
                        }

                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
//
// var marker =(LatLng latLong)=> const Marker(
//   markerId: MarkerId('Company1'),
//   position:latLong ,
//   infoWindow: InfoWindow(
//     title: 'Van Tracker',
//     snippet: 'googleplex',
//   ),
// );
}
