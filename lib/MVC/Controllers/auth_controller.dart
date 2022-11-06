import 'dart:convert';

import 'package:car_tracking_system/Constants/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/collections.dart';
import '../Models/company_model.dart';
import '../Views/admin/forms/login.dart';
import '../Views/admin/list_of_drivers.dart';
import '../Views/rider/rider_map.dart';

class AuthController {
  AuthController._private();
  final auth = 'authLogin';
  static final instance = AuthController._private();

  Future save(Company company) async {
    Map<String, dynamic> _comp = company.toMap();
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(auth, company.toJson());

    // for (var key in _comp.keys) {
    //   if (key != 'points') {
    //     print('$key:${_comp[key]}');
    //     await prefs.setString(key, _comp[key]);
    //   } else {
    //     print('$key:${_comp[key]}');
    //
    //     await prefs.setStringList(
    //         key, <String>['${_comp[key][0]}', '${_comp[key][1]}']);
    //   }
    // }
  }

  Future<String?> getDriverAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth');
  }

  void saveDriverAuth(String auth) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth', auth);
  }

  Future<Company> get() async {
    final prefs = await SharedPreferences.getInstance();
    Company comp = Company.fromJson(prefs.getString(auth)!);
// print('get Function:${comp.id}');
    return comp;
    // return Company(
    //   id: prefs.getString('id'),
    //   name: prefs.getString('name'),
    //   email: prefs.getString('email'),
    //   points:
    //       prefs.getStringList('points')?.map((e) => double.parse(e)).toList(),
    //   biography: prefs.getString('biography'),
    //   license: prefs.getString('license'),
    //   phone: prefs.getString('phone'),
    //   password: prefs.getString('password'),
    // );
  }

  void driverLogin(BuildContext context, String auth) async {
    await FirebaseFirestore.instance
        .collection(Collection.company)
        .doc(auth.split('%')[0])
        .collection(Collection.drivers)
        .doc(auth.split('%')[1])
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.exists) {
        AuthController.instance.saveDriverAuth(auth);
        App.instance
            .snackBar(context, text: 'Validated!!', bgColor: Colors.green);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RiderLiveMaps(
                      token: auth,
                    )));
      } else {
        App.instance.snackBar(context,
            text: 'Wrong Credentials!!', bgColor: Colors.redAccent);
      }
    });
  }

  Future<Company> login(BuildContext context, {email, password}) async {
    return FirebaseFirestore.instance
        .collection(Collection.company)
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        // print(jsonEncode(querySnapshot.docs.first));
        Company a = querySnapshot.docs
            .map((e) => Company.fromJson(jsonEncode(e.data())))
            .toList()
            .first;

        App.instance.snackBar(context, text: 'Done!!', bgColor: Colors.green);
        await save(a);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DriversList()));

        return a;
      } else {
        App.instance.snackBar(context,
            text: 'Wrong Credentials!!', bgColor: Colors.redAccent);

        return Company();
      }
    });
  }

  logout(BuildContext context) async {
    Company? company = Company(
        name: 'name',
        biography: 'biography',
        license: 'license',
        phone: 'phone',
        email: 'email',
        points: [],
        password: 'password',
        id: 'id');
    Map<String, dynamic> _comp = company.toMap();
    final prefs = await SharedPreferences.getInstance();
    for (var key in _comp.keys) {
      if (key != 'points') {
        // print('$key:${_comp[key]}');
        await prefs.setString(key, '');
      } else {
        // print('$key:${_comp[key]}');

        await prefs.setStringList(key, <String>[]);
      }
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginCompany()));
  }
}
