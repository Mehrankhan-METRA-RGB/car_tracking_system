import 'dart:convert';
import 'dart:developer';

import 'package:car_tracking_system/Constants/widgets/widgets.dart';
import 'package:car_tracking_system/MVC/Models/collections.dart';
import 'package:car_tracking_system/MVC/Models/instructions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Models/company_model.dart';

class CompanyController {
  CompanyController._private();

  static final instance = CompanyController._private();

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
      {required String collection, required Company data}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(collection);

    // Call the user's CollectionReference to add a new user
    return users.add(data.toMap()).then((value) {
      users.doc(value.id).update({'id': value.id});
      App.instance.snackBar(context, text: 'Done!! ');
      // print('done');

      // AppBanner.instance.show(context,submissionText: 'Done',onSubmit: ()async{Navigator.pop(context);},  content: const Text('Done  Successfully'),backgroundColor: Colors.green);
      return value;
    }).catchError((error) {
      App.instance.snackBar(context, text: 'Error ');
    });
  }

  Future<List<Company>> fetch({collection}) async {
    return FirebaseFirestore.instance.collection(collection).get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((e) => Company.fromJson(jsonEncode(e.data())))
            .toList());
  }

  Future<void> delete(BuildContext context, {companyId, driverId}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(Collection.company);

    return users
        .doc(companyId)
        .collection(Collection.drivers)
        .doc(driverId)
        .delete()
        .then((value) => App.instance.snackBar(context,
            text: 'Deleted successfully', bgColor: Colors.blue))
        .catchError((error) => App.instance.snackBar(context,
            text: "Failed to delete : $error", bgColor: Colors.red));
  }

  Future<void> sendInstructions(Instruction message, {compId, driverId}) async {
    CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore.instance
        .collection(Collection.company)
        .doc(compId)
        .collection(Collection.drivers)
        .doc(driverId)
        .collection(Collection.instructions);

    ref.add(message.toMap()).then((a) {
      a.update({'id': a.id});
    });

    log('~~ Message sent ~~');
  }

  Future<List<Company>> fetchInstruction({collection, compId, driverId}) async {
    CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore.instance
        .collection(Collection.company)
        .doc(compId)
        .collection(Collection.drivers)
        .doc(driverId)
        .collection(Collection.instructions);
    return FirebaseFirestore.instance.collection(collection).get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((e) => Company.fromJson(jsonEncode(e.data())))
            .toList());
  }
}
