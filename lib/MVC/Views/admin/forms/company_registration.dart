import 'package:car_tracking_system/MVC/Models/company_model.dart';
import 'package:car_tracking_system/MVC/Views/partials/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../partials/buttons.dart';

import 'after_company_registration.dart';

class RegisterCompany extends StatefulWidget {
  const RegisterCompany({Key? key}) : super(key: key);

  @override
  _RegisterCompanyState createState() => _RegisterCompanyState();
}

class _RegisterCompanyState extends State<RegisterCompany> {
  final TextEditingController name = TextEditingController();
  final TextEditingController regNo = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController password = TextEditingController();
  LatLng positions = const LatLng(122.23232323, -35.343434344);
  final registrationFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   actions: [
      //     TextButton(
      //       child: const Text(
      //         'Go to Login',
      //         style: TextStyle(fontSize: 14, color: Colors.white),
      //       ),
      //       onPressed: () {
      //         Navigator.pushReplacement(context,
      //             MaterialPageRoute(builder: (context) => const Login()));
      //       },
      //     ),
      //   ],
      // ),
      body: Form(
        key: registrationFormKey,
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 4, left: 20, right: 20),
              child: Text(
                'Company',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            AppTextField(
              hint: 'Company Name',
              controller: name,
              onChange: (a) {},
            ),
            AppTextField(
              hint: 'Reg No',
              controller: regNo,
              onChange: (a) {},
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 4, left: 20, right: 20),
              child: Text(
                'Corporate Email',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            AppTextField(
              hint: 'Corporate Email',
              controller: email,
              onChange: (a) {},
            ),
            AppTextField(
              hint: 'Company Phone',
              controller: phone,
              onChange: (a) {},
            ),
            AppTextField(
              hint: 'Description',
              controller: desc,
              onChange: (a) {},
            ),
            AppTextField(
              hint: 'Password',
              isPassword: true,
              controller: password,
              onChange: (a) {},
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0,bottom: 80),
              child: AppButton(
                child: const Text('Next'),
                onPressed: () {
                  if (registrationFormKey.currentState!.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AfterRegistration(
                                  data: Company(
                                    name: name.text,
                                    email: email.text,
                                    biography: desc.text,
                                    license: regNo.text,
                                    password: password.text,
                                    phone: phone.text,
                                  ),
                                )));
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
