import 'dart:convert';

import 'package:car_tracking_system/MVC/Controllers/Repository/dynamic_links.dart';
import 'package:car_tracking_system/MVC/Controllers/auth_controller.dart';
import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Models/company_model.dart';
import 'package:car_tracking_system/MVC/Models/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Constants/widgets/widgets.dart';
import '../../Models/collections.dart';
import 'driverOptions/change_destination.dart';
import 'driverOptions/chat_to_driver.dart';
import 'driverOptions/show_live_map.dart';
import 'forms/vehicle_registration.dart';

class DriversList extends StatefulWidget {
  const DriversList({Key? key}) : super(key: key);

  @override
  DriversListState createState() => DriversListState();
}

class DriversListState extends State<DriversList> {
  Company? company;
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
        company = value;
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
                      .doc(company?.id)
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
                                  trailing: App.instance.menu(
                                      icon: Icons.more_vert,
                                      iconColor: Colors.green,
                                      items: [
                                        menuItem(
                                            title: 'Live',
                                            value: 1,
                                            icon: Icons.location_on),
                                        menuItem(
                                            title: 'Destinations',
                                            value: 2,
                                            icon: Icons.drive_eta),
                                        menuItem(
                                            title: 'Instruction',
                                            value: 3,
                                            icon: Icons.mark_email_read_sharp),
                                        menuItem(
                                            title: 'Share Token',
                                            value: 4,
                                            icon: Icons.share),
                                        menuItem(
                                            title: 'Security Link Share',
                                            value: 5,
                                            icon: Icons.security),
                                        menuItem(
                                            title: 'Delete Driver',
                                            value: 6,
                                            icon: Icons.delete),
                                      ],
                                      onSelected: (a) async {
                                        switch (a) {
                                          case 1:
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
                                                    companyId: company?.id,
                                                  ),
                                                ));
                                            break;
                                          case 2:
                                            App.instance.dialog(context,
                                                child: ChangeDestination(
                                                  comp: company,
                                                  driver: _driver,
                                                ));
                                            break;
                                          case 3:
                                            App.instance.dialog(context,
                                                child: ChatToDriver(
                                                  company: company,
                                                  driver: _driver,
                                                ));
                                            break;
                                          case 4:

                                            ///Share Driver Token
                                            String token =
                                                '${company?.id}%${_driver.id}';
                                            await Share.share(token,
                                                subject:
                                                    'Token for ${_driver.driverName}');
                                            break;
                                          case 5:

                                            ///Share Driver Token
                                            String token =
                                                '${company?.id}%${_driver.id}';

                                            await DynamicLinks
                                                    .createDynamicLink(
                                                        true, token)
                                                .then((link) async =>
                                                    await Share.share(link,
                                                        subject:
                                                            'Security Link For Driver name ${_driver.driverName} from Company ${company?.name}'));

                                            break;
                                          case 6:

                                            ///`delete` Driver
                                            await CompanyController.instance
                                                .delete(context,
                                                    companyId: company?.id,
                                                    driverId: _driver.id);
                                            break;
                                        }
                                      }),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterDriver(
                        prefs: company,
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

  PopupMenuItem menuItem(
      {required String title, required dynamic value, required IconData icon}) {
    return PopupMenuItem(
      textStyle: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: Colors.black54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(
            icon,
            size: 15,
            color: Colors.green,
          ),
        ],
      ),
      value: value,
    );
  }
}
