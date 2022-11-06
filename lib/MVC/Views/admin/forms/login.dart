import 'package:car_tracking_system/MVC/Controllers/auth_controller.dart';
import 'package:car_tracking_system/MVC/Views/partials/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../partials/buttons.dart';
import 'company_registration.dart';

class LoginCompany extends StatefulWidget {
  const LoginCompany({Key? key}) : super(key: key);

  @override
  _LoginCompanyState createState() => _LoginCompanyState();
}

class _LoginCompanyState extends State<LoginCompany> {
  final TextEditingController email = TextEditingController();
  bool isRegister = false;
  final TextEditingController password = TextEditingController();
  LatLng positions = const LatLng(122.23232323, -35.343434344);
  final registrationFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    await AuthController.instance.get().then((prefs) {
      if (prefs.email != null && prefs.password != null) {
        email.text = prefs.email!;
        password.text = prefs.password!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Login'),
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //     actions: [
        //
        //     ],
        // ),
        body: isRegister
            ? const RegisterCompany()
            : Form(
                key: registrationFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextField(
                      hint: 'Email',
                      controller: email,
                      onChange: (a) {},
                    ),
                    AppTextField(
                      hint: 'Password',
                      isPassword: true,
                      controller: password,
                      onChange: (a) {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : AppButton(
                              child: const Text('Login'),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (registrationFormKey.currentState!
                                    .validate()) {
                                  await Future.delayed(
                                      const Duration(
                                        seconds: 2,
                                      ), () {
                                    AuthController.instance
                                        .login(context,
                                            email: email.text,
                                            password: password.text)
                                        .then((value) => setState(() {
                                              isLoading = false;
                                            }));
                                  });
                                }
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: TextButton(
                        child: const Text(
                          'Register Now',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        onPressed: () {
                          setState(() {
                            isRegister = true;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
        floatingActionButton: isRegister
            ? FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    isRegister = false;
                  });
                },
                label: const Text(
                  'Back to Login',
                ),
              )
            : null);
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
