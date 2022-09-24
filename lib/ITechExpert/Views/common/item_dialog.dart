import 'package:car_tracking_system/ITechExpert/Controller/cart_controller.dart';
import 'package:car_tracking_system/ITechExpert/Data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDialog extends StatelessWidget {
  const ItemDialog({Key? key}) : super(key: key);
  static final TextEditingController _discountController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map productsCount = context.watch<CartController>().productCount;
    List keys = context.watch<CartController>().productCount.keys.toList();
    keys.sort();

    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 450,
        child: Column(
          children: [
            Container(
              height: 30,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.teal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: const [
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Item',
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(
                        'Price',
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Count',
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'Buttons',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 40,
                      color: Colors.black12,
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text(
                                items
                                    .firstWhere((e) => e.id == keys[index])
                                    .title!,
                                overflow: TextOverflow.ellipsis,
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                (double.parse(items
                                            .firstWhere(
                                                (e) => keys[index] == e.id)
                                            .price!) *
                                        context
                                            .watch<CartController>()
                                            .productCount[keys[index]])
                                    .toString(),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                productsCount[keys[index]].toString(),
                              )),
                          Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => context
                                        .read<CartController>()
                                        .addItemCart(items.firstWhere(
                                            (e) => e.id == keys[index])),
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      size: 16,
                                    ),
                                  ),
                                  // Container(
                                  //   width: 1,
                                  //   color: Colors.black12,
                                  //   height: double.infinity,
                                  //   // margin:
                                  //   //     const EdgeInsets.symmetric(horizontal: 5),
                                  // ),
                                  IconButton(
                                    onPressed: () => context
                                        .read<CartController>()
                                        .removeItemFromCart(items.firstWhere(
                                            (e) => e.id == keys[index])),
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Colors.teal,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          '${context.watch<CartController>().totalPrice}\$',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount:',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _discountController,
                            textAlign: TextAlign.right,
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white54))),
                            onChanged: (a) =>
                                context.read<CartController>().discount(a),
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
