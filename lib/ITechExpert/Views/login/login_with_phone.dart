import 'package:flutter/material.dart';
import '../../../Constants/widgets/widgets.dart';
import '../../../MVC/Views/partials/text_field.dart';
import 'otp.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  TextEditingController phoneController =
      TextEditingController(text: "+923000000000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              controller: phoneController,
              hint: 'Phone Number',
              inputType: TextInputType.phone,
            ),
            const SizedBox(
              height: 10,
            ),
            App.instance.button(context, color: Colors.teal, onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OTPScreen(phoneController.text)));
            }, child: const Text('Send OTP')),
          ],
        ),
      ),
    );
  }
}
