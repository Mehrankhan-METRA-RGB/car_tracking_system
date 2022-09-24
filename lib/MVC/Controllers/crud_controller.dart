import 'dart:convert';
import 'dart:typed_data';
import 'package:car_tracking_system/Constants/failure_dialog.dart';
import 'package:car_tracking_system/Constants/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Constants/success_dialog.dart';
import '../Models/driver_model.dart';

//
// import '../../constants/packages/banner/banner_widget.dart';
// import '../../constants/success_dialog.dart';

class FirebaseCRUD {
  FirebaseCRUD._private();
  static final instance = FirebaseCRUD._private();
//////////////
//////////////////
/////////////////////
////////////////////////
////// Firebase CRUD ////////
////////////////////////
/////////////////////
//////////////////
//////////////
  ///when image is successfully uploaded to server it will return a an [UploadTask],
  ///
  ///This can be useful for getting uploading details.
  ///
  ///
  Future<String> uploadImageAndGetUrl(BuildContext context,
      {required Uint8List file,
        required String extension,
        required String directory,

        /// final ProgressController progress = Get.put(ProgressController());
        dynamic controller,
        int count = 0,
        required String name}) async {
    // File file =File(path);
    fire_storage.UploadTask task = fire_storage.FirebaseStorage.instance
        .ref('$directory/$name.$extension')
        .putData(
      file,
      fire_storage.SettableMetadata(contentType: 'image/$extension'),
    );

    double _progress = 0;
    task.snapshotEvents.listen((fire_storage.TaskSnapshot snapshot) {
      if (kDebugMode) {
        print('Task state: ${snapshot.state}');
      }
      _progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      controller.val(_progress, count: count);
      // print(
      //     'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      if (kDebugMode) {
        print(task.snapshot);
      }

      if (e.code == 'permission-denied') {
        if (kDebugMode) {
          print('User does not have permission to upload to this reference.');
        }
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      fire_storage.TaskSnapshot snapshot = await task;

      return snapshot.ref.getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        if (kDebugMode) {
          print('User does not have permission to upload to this reference.');
        }
      }
      return 'null';

      // ...
    }

    //
    //
    // try {
    //   // Storage tasks function as a Delegating Future so we can await them.
    //   fire_storage.TaskSnapshot snapshot = await task;
    //   App.instance.snackBar(context,
    //       bgColor: Colors.green,
    //       text: 'Uploaded ${(snapshot.bytesTransferred / 1024).round()} KB.');
    //   return snapshot.ref.getDownloadURL();
    // } on firebase_core.FirebaseException catch (e) {
    //   // The final snapshot is also available on the task via `.snapshot`,
    //   // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
    //   App.instance.snackBar(context,
    //       bgColor: Colors.red, text: 'Failed ${task.snapshot}.');
    //   return 'null';
    //   if (e.code == 'permission-denied') {
    //     print('User does not have permission to upload to this reference.');
    //   }
    //   // ...
    // }
  }

  Future<void> update(BuildContext context,
      {required String collection,
        required String document,
        required Map<String, Object?> data}) async {
    CollectionReference users =
    FirebaseFirestore.instance.collection(collection);

    await  users
        .doc(document)
        .update(data)
        .then((value) {
      App.instance.snackBar(context,text: 'Done!!');
    })

        .catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      App.instance.snackBar(context,text: 'Failed to update ');

      // App.instance.snackBar(context, text: "Failed to update user: $error",bgColor: Colors.redAccent);
    });
  }

  Future<DocumentReference> add(BuildContext context,
      {required String collection, required Map<String, Object?> data}) {
    CollectionReference users =
    FirebaseFirestore.instance.collection(collection);

    // Call the user's CollectionReference to add a new user
    return users.add(data).then((value) {
      users.doc(value.id).update({'id': value.id});
      App.instance.snackBar(context,text: 'Added Done!!');

      // AppBanner.instance.show(context,submissionText: 'Done',onSubmit: ()async{Navigator.pop(context);},  content: const Text('Done  Successfully'),backgroundColor: Colors.green);
      return value;
    }).catchError((error) {
      App.instance.snackBar(context,text: 'Error while Adding ');
    });
  }

  Future<List<Driver>> fetch({collection}) async {
    return FirebaseFirestore.instance.collection(collection).get().then(
            (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((e) => Driver.fromJson(jsonEncode(e.data())))
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

  // ///This will restore roles to default
  // Future defaultRoles() async {
  //   CollectionReference users =
  //   FirebaseFirestore.instance.collection(Collection.instance.role);
  //
  //   for (var doc in roleAccess.keys) {
  //     users.doc(doc).set(roleAccess[doc]);
  //   }
  // }

  ///Fetch Roles
  // Future<List<String>> fetchRole() async {
  //   List<String> loc = [];
  //   CollectionReference ref =
  //   FirebaseFirestore.instance.collection(Collection.instance.role);
  //   await ref
  //       .get()
  //       .then((value) => value.docs.toList().forEach((element) {
  //     loc.add(element.id);
  //   }))
  //       .whenComplete(() {
  //     Company.rolesList = loc;
  //   });
  //
  //   if (kDebugMode) {
  //     print('Roles Loaded for ${Company.currentAdminValues.office}');
  //   }
  //   return loc;
  // }

  // ///Fetch references
  // Future<List<ReferenceModel>> fetchReference() async {
  //   CollectionReference ref =
  //   FirebaseFirestore.instance.collection(Collection.instance.reference);
  //   // print(Default.currentAdminValues.office);
  //   Default.referencesList = await ref
  //       .where('office', isEqualTo: Default.currentAdminValues.office)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) => querySnapshot.docs
  //       .map((e) => ReferenceModel.fromJson(json.encode(e.data())))
  //       .toList());
  //   if (kDebugMode) {
  //     print('References Loaded for ${Default.currentAdminValues.office}: ${Default.referencesList}');
  //   }
  //   return Default.referencesList;
  // }

  // Future<List<dynamic>> fetchOffices() async {
  //   CollectionReference ref =
  //   FirebaseFirestore.instance.collection(Collection.instance.offices);
  //
  //   Default.officeList = await ref.get().then((QuerySnapshot querySnapshot) =>
  //       querySnapshot.docs
  //           .map((e) => OfficeModel.fromJson(jsonEncode(e.data())))
  //           .toList());
  //   print('Offices loaded');
  //   return Default.officeList;
  // }

  // ///Fetch Courses
  // Future<List<CourseModel>> fetchCourses() async {
  //   Default.coursesList = await FirebaseFirestore.instance
  //       .collection(Collection.instance.course)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) => querySnapshot.docs
  //       .map((e) => CourseModel.fromJson(json.encode(e.data())))
  //       .toList());
  //   return Default.coursesList;
  // }
}

//////////////
//////////////////
/////////////////////
////////////////////////
//////Firebase Collections////////
////////////////////////
/////////////////////
//////////////////
//////////////
