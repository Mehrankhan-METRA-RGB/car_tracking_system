import 'package:car_tracking_system/ITechExpert/Controller/Repository/dynamic_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ITechExpert/Controller/cart_controller.dart';
import 'ITechExpert/Views/home.dart';
import 'package:firebase_core/firebase_core.dart';

import 'MVC/Views/Tests/live_locations_test.dart';
import 'MVC/Views/admin/forms/company/login.dart';
import 'MVC/Views/rider/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CartController>(create: (_) => CartController()),

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Tracking System ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:
      // const LoginDriver()
      const LiveMaps()

      // const Login(),

      // FirebaseAuth.instance.currentUser!=null
      //     ? const Home()
      //     : const LoginWithPhone(),
    );
  }
}
