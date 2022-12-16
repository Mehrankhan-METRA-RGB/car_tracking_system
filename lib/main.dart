import 'package:car_tracking_system/MVC/Controllers/Rider/RiderMap/rider_map_controller.dart';
import 'package:car_tracking_system/MVC/Views/admin/forms/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_notify/native_notify.dart';

import 'MVC/Controllers/Repository/dynamic_links.dart';
import 'MVC/Views/rider/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  NativeNotify.initialize(2007, 'o5LrrkKjDVraW27Xp2yp2Z', null, null);
  runApp(const MyApp());
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<RiderMapCubit>(create: (context) => RiderMapCubit()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Car Tracking System ',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const TabsPage()),
    );
  }
}

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeepLink(context);
  }

  bool isLoading = true;
  Future<void> initDeepLink(BuildContext context) async {
    await DynamicLinks.initDynamicLink(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                color: Color(0xf41a7721),
              ),
            ),
          )
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: 'Driver',
                      icon: Icon(Icons.drive_eta_sharp),
                    ),
                    Tab(
                        text: 'Company',
                        icon: Icon(Icons.admin_panel_settings_rounded)),
                  ],
                ),
                title: const Text('Login'),
              ),
              body: const TabBarView(
                children: [
                  LoginDriver(),
                  LoginCompany(),
                ],
              ),
            ),
          );
  }
}
