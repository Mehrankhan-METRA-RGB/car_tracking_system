import 'dart:convert';

import 'package:car_tracking_system/Constants/widgets/widgets.dart';
import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Models/Collections.dart';
import 'package:car_tracking_system/MVC/Views/admin/list_of_drivers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Models/company_model.dart';
import '../Models/driver_model.dart';

class DriverController {
  DriverController._private();

  static final instance = DriverController._private();
  Company? prefs;

  Future<void> update(BuildContext context,
      {required String collection,
      required String document,
      required Map<String, Object?> data}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(collection);

    await users.doc(document).update(data).then((value) {
      App.instance.snackBar(context, text: 'Done!! ');
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      App.instance.snackBar(context, text: 'Error!! ');

      // App.instance.snackBar(context, text: "Failed to update user: $error",bgColor: Colors.redAccent);
    });
  }

  Future<DocumentReference> add(BuildContext context,
      {required Driver data, Company? prefs}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(Collection.company);
    return users
        .doc(prefs?.id)
        .collection(Collection.drivers)
        .add(data.toMap())
        .then((value) {
      print(value.id);
      users
          .doc(prefs?.id)
          .collection(Collection.drivers)
          .doc(value.id)
          .update({'id':value.id});
      App.instance
          .snackBar(context, text: 'driver Added!! ', bgColor: Colors.green);
      // print('done');

      // AppBanner.instance.show(context,submissionText: 'Done',onSubmit: ()async{Navigator.pop(context);},  content: const Text('Done  Successfully'),backgroundColor: Colors.green);
      return value;
    }).catchError((error) {
      App.instance.snackBar(context, text: 'Error:$error ');
    });
  }

  Future<Company> login(BuildContext context, {email, password}) async {
    return FirebaseFirestore.instance
        .collection(Collection.company)
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var a = querySnapshot.docs
            .map((e) => Company.fromJson(jsonEncode(e.data())))
            .toList()
            .first;
        App.instance.snackBar(context, text: 'Done!!', bgColor: Colors.green);
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

  Future<List<Company>> fetch({collection}) async {
    return FirebaseFirestore.instance.collection(collection).get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((e) => Company.fromJson(jsonEncode(e.data())))
            .toList());
  }

  Future<void> delete(BuildContext context, {collection, docs}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(collection);

    return users
        .doc(docs)
        .delete()
        .then((value) => App.instance.snackBar(context,
            text: 'Deleted successfully', bgColor: Colors.blue))
        .catchError((error) => App.instance.snackBar(context,
            text: "Failed to delete : $error", bgColor: Colors.red));
  }

  Future<void> updateCurrentLocation(
      {required String companyId,
      required String driverId,
        String key='permanentPoints',
      required List<double> data}) async {
    DocumentReference<Map<String, dynamic>> users = FirebaseFirestore.instance
        .collection(Collection.company)
        .doc(companyId)
        .collection(Collection.drivers)
        .doc(driverId);
    await users.update({key: data});
  }
}
