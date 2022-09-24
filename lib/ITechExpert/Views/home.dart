import 'package:flutter/material.dart';
import '../Controller/Repository/dynamic_links.dart';
import '../Data/data.dart';
import 'common/appbar.dart';
import 'common/item_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeepLink(context);
  }
  initDeepLink(BuildContext context)async{
    await DynamicLinks.initDynamicLink(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [


          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                      child: Column(children: [
                    Expanded(
                      child: ItemCard(
                        fit: BoxFit.fill,
                        item: items[0],
                      ),
                    ),
                    Expanded(
                      child: ItemCard(
                        fit: BoxFit.fill,
                        item: items[1],
                      ),
                    ),
                  ])),
                  Expanded(
                    child: ItemCard(
                      fit: BoxFit.fill,
                      item: items[5],
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 1,
              child: ItemCard(
                fit: BoxFit.fill,
                item: items[3],
              )),
          Expanded(
              flex: 1,
              child: Row(children: [
                Expanded(
                  child: ItemCard(
                    fit: BoxFit.fill,
                    item: items[2],
                  ),
                ),
                Expanded(
                  child: ItemCard(
                    fit: BoxFit.fill,
                    item: items[4],
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
