import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({required this.items, Key? key}) : super(key: key);
  final List<Widget> items;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow()],
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}

class BottomBarItem {
  show({IconData? icon, String? title, double size = 20}) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        size: size,
      ),
    );
  }
}
