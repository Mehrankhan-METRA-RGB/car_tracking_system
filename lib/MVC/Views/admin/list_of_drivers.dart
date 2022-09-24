import 'dart:convert';

import 'package:car_tracking_system/MVC/Controllers/auth_controller.dart';
import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Models/company_model.dart';
import 'package:car_tracking_system/MVC/Models/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Constants/widgets/widgets.dart';
import '../../Models/Collections.dart';
import 'forms/driver/show_live_map.dart';
import 'forms/driver/vehicle_registration.dart';

class DriversList extends StatefulWidget {
  const DriversList({Key? key}) : super(key: key);

  @override
  dvrsListState createState() => dvrsListState();
}

class dvrsListState extends State<DriversList> {
  Company? prefs;
  TextEditingController searchController = TextEditingController();
  List<Driver>? drivers;
  List<Driver>? tempDrivers;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    await AuthController.instance.get().then((value) {
      setState(() {
        prefs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Name'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              AuthController.instance.logout(context);
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 1.0, bottom: 2, left: 5, right: 5),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search ...',
                suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.green,
                    )),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(Collection.company)
                      .doc(prefs?.id)
                      .collection(Collection.drivers)
                      .snapshots(),
                  builder: (context, snapshot) {
                    drivers = snapshot.data?.docs
                        .map((e) => Driver.fromJson(jsonEncode(e.data())))
                        .toList();

                    List<Driver>? dvrs;
                    if (searchController.text.isNotEmpty) {
                      dvrs = tempDrivers;
                    } else {
                      dvrs = drivers;
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: dvrs?.length,
                          itemBuilder: (context, count) {
                            Driver _driver = dvrs![count];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5),
                              child: Card(
                                child: ListTile(
                                  leading: Text('${count + 1}'),
                                  title: Text(_driver.driverName!),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${_driver.vehicleName}'),
                                      Text(
                                        '${_driver.driverPhone}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                color: Colors.grey,
                                                fontSize: 9),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      print('${_driver.id} === ${prefs?.id}');
                                      App.instance.dialog(context,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: ShowLiveDriver(
                                              driverId: _driver.id,
                                              companyId: prefs?.id,
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Container();
                    }
                  })),
        ],
      ),
      // bottomNavigationBar: SizedBox(
      //   height: 55,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       IconButton(
      //           onPressed: () {
      //
      //           },
      //           iconSize: 37,
      //           color: Colors.green,
      //           tooltip: 'Add  vehicle',
      //           icon: const Icon(Icons.add))
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterVehicle(
                        prefs: prefs,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onSearchChanged(String text) {
    if (drivers!.isNotEmpty) {
      setState(() {
        tempDrivers = drivers
            ?.where((element) => element.driverName!
                .toLowerCase()
                .startsWith(text.toLowerCase()))
            .toList();
      });
    }
  }
}
