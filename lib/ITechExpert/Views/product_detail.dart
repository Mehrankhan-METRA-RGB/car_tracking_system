import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../Constants/widgets/widgets.dart';
import '../Controller/Repository/dynamic_links.dart';
import '../Controller/cart_controller.dart';
import '../Controller/screen_controller.dart';
import '../Model/item_model.dart';
import 'common/appbar.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({required this.item, Key? key}) : super(key: key);
  final Item item;
  static final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: RepaintBoundary(
        key: _globalKey,
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 60,
                child: Image.asset(
                  'assets/itech/${item.image}',
                  fit: BoxFit.fill,
                )),
            Positioned(
                top: 10,
                right: 10,
                child: Container(
                  height: 110,
                  width: 60,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () => _showModalBottomSheet(context, item),
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.teal,
                        ),
                      ),
                      MaterialButton(
                          onPressed: () async =>
                              await DynamicLinks.createDynamicLink(true, item)
                                  .then((link)async =>    await Share.share
                                  (
                                       link,subject: 'The Itech App Link ')),
                          child: const Icon(
                            Icons.share,
                            color: Colors.teal,
                          )),
                    ],
                  ),
                )),
            Positioned(
                bottom: 50,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  // color: const Color(0xcad7d5d5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.teal),
                      ),
                      Text(
                        '${item.price}\$',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.teal),
                      ),
                    ],
                  ),
                )),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                width: 210,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () => context
                            .read<CartController>()
                            .removeItemFromCart(item),
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.white,
                          size: 25,
                        )),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white,
                    ),
                    IconButton(
                        onPressed: () =>
                            context.read<CartController>().addItemCart(item),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 25,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Cart: ${(context.watch<CartController>().productCount[item.id] ?? 0).toString()}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, Item item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.grey.shade200,
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () async {
                  await ScreenController().capturePng(_globalKey).then((bytes) {
                    ScreenController().saveImage(bytes!).whenComplete(() {
                      App.instance.snackBar(context,
                          text: 'Image Saved', bgColor: Colors.orange);
                      Navigator.pop(context);
                    });
                  });
                },
                child: const Text("Widget Save To Gallery"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () async {
                  await ScreenController()
                      .takeImageBytes(item.image!)
                      .then((bytes) {
                    ScreenController().saveImage(bytes).whenComplete(() {
                      App.instance.snackBar(context,
                          text: 'Image Saved', bgColor: Colors.orange);
                      Navigator.pop(context);
                    });
                  });
                },
                child: const Text("Image Save To Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }
}
