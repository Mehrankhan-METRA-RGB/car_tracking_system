import 'package:car_tracking_system/ITechExpert/Views/common/item_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../Constants/widgets/widgets.dart';
import '../../Controller/cart_controller.dart';
import '../login/login_with_phone.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor),
      title: const Text('Application'),
      actions: [

        cartButton(context,onTap: (){App.instance.dialog(context, child: const ItemDialog());}),
        // IconButton(
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut();
        //       Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const LoginWithPhone()));
        //     },
        //     icon: const Icon(
        //       Icons.logout_sharp,
        //       size: 18,
        //     ))
      ],
    );
  }

  Widget cartButton(BuildContext context, {void Function()? onTap}) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
              onPressed: onTap ?? () {},
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              )),
          context.watch<CartController>().items.isEmpty
              ? Container()
              : Positioned(
                  top: 5,
                  right: 5,
                  child: ClipOval(
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      color: Colors.orange,
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        '${context.watch<CartController>().items.length}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
