import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Controllers/driver_controller.dart';
import 'package:car_tracking_system/MVC/Models/company_model.dart';
import 'package:car_tracking_system/MVC/Views/partials/text_field.dart';
import 'package:flutter/material.dart';

import '../../../../Models/driver_model.dart';
import '../../../partials/buttons.dart';

class RegisterVehicle extends StatefulWidget {
  const RegisterVehicle({this.prefs, Key? key}) : super(key: key);
  final Company? prefs;
  @override
  _RegisterVehicleState createState() => _RegisterVehicleState();
}

class _RegisterVehicleState extends State<RegisterVehicle> {
  final TextEditingController driverName = TextEditingController();
  final TextEditingController driverPhone = TextEditingController();
  final TextEditingController vehicleName = TextEditingController();
  final TextEditingController vehicleNumber = TextEditingController();
  final TextEditingController vehicleChassis = TextEditingController();
  final registrationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Form(
        key: registrationFormKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 4, left: 20, right: 20),
              child: Text(
                'Driver',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            AppTextField(
              hint: 'Driver Name',
              controller: driverName,
            ),
            AppTextField(
              hint: 'Driver Phone',
              controller: driverPhone,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 4, left: 20, right: 20),
              child: Text(
                'Vehicle',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            AppTextField(
              hint: 'Vehicle Name',
              controller: vehicleName,
            ),
            AppTextField(
              hint: 'Vehicle Reg.No',
              controller: vehicleNumber,
            ),
            AppTextField(
              hint: 'Vehicle Chassis',
              controller: vehicleChassis,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: AppButton(
                child: const Text('Submit'),
                onPressed: () {
                  // CompanyController.instance
                  //     .getCompanyLocal()
                  //     .then((value) => print(value.toMap()));

                  if (registrationFormKey.currentState!.validate()) {
                    DriverController.instance.add(context,
                        prefs: widget.prefs,
                        data: Driver(
                          driverName: driverName.text,
                          driverPhone: driverPhone.text,
                          companyId: widget.prefs?.id,
                          vehicleName: vehicleName.text,
                          vehicleRegNo: vehicleNumber.text,
                          vehicleChassis: vehicleChassis.text,
                          permanentPoints: [13.45456, 45.556556],
                          destinationPoints: [13.45456, 45.556556],
                          nextPoints: [13.45456, 45.556556],
                        ));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
