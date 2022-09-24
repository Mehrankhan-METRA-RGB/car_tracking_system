import 'package:car_tracking_system/MVC/Controllers/auth_controller.dart';
import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Models/company_model.dart';
import 'package:car_tracking_system/MVC/Views/partials/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../partials/buttons.dart';
import 'company_registration.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();
  LatLng positions = const LatLng(122.23232323, -35.343434344);
  final registrationFormKey = GlobalKey<FormState>();
  bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  getData()async{
    await    AuthController.instance.get().then((prefs) {
      if(prefs.email!=null&&prefs.password!=null){
        email.text=prefs.email!;
        password.text=prefs.password!;
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        elevation: 0,
      ),
      body: Form(
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
              child:   isLoading
                  ? const CircularProgressIndicator()
                  :
              AppButton(
                child: const Text('Login'),
                onPressed: ()async {
                  setState(() {
                    isLoading = true;
                  });
                  if (registrationFormKey.currentState!.validate()) {
    await Future.delayed(
    const Duration(
    seconds: 2,
    ), () {
      AuthController.instance
          .login(context, email: email.text, password: password.text);
    });

                  }

                  setState(() {
                    isLoading = false;
                  });
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterCompany()));
                },
              ),
            )
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
