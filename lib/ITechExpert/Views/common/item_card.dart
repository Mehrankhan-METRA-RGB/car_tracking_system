import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/cart_controller.dart';
import '../../Model/item_model.dart';
import '../product_detail.dart';

class ItemCard extends StatefulWidget {
  const ItemCard(
      {this.width,
      this.fit,
      this.height,
      required this.item,
      this.onAddClick,
      Key? key})
      : super(key: key);
  final double? height;
  final double? width;
  final Item item;
  final BoxFit? fit;
  final void Function()? onAddClick;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // final void Function()? onItemClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      height: widget.height ?? double.infinity,
      width: widget.width ?? double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(item: widget.item)));
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/itech/${widget.item.image}',
                    fit: widget.fit,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    color: const Color(0x6fffffff),
                    width: widget.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          widget.item.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
                        ElevatedButton(
                          onPressed: () => context
                              .read<CartController>()
                              .addItemCart(widget.item),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(40, 40),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
