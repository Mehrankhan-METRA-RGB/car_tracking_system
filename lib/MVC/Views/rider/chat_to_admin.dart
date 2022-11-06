import 'dart:convert';
import 'package:car_tracking_system/MVC/Controllers/company_controller.dart';
import 'package:car_tracking_system/MVC/Models/instructions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:native_notify/native_notify.dart';
import '../../Models/collections.dart';

class ChatToAdmin extends StatelessWidget {
  const ChatToAdmin({this.companyId, this.driverId, Key? key})
      : super(key: key);
  final String? companyId;
  final String? driverId;
  static TextEditingController messageController = TextEditingController();
  static GlobalKey<FormState> messageKey = GlobalKey<FormState>();
  static ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: MediaQuery.of(context).size.width * 0.8,
      // padding: const EdgeInsets.only(t: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 20.0),
                //   child: Text(driver!.driverName!,style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),),
                // ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection(Collection.company)
                    .doc(companyId)
                    .collection(Collection.drivers)
                    .doc(driverId)
                    .collection(Collection.instructions)
                    .orderBy('dateTime', descending: true)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    List<Instruction>? inst = snapshots.data!.docs
                        .map((e) => Instruction.fromJson(jsonEncode(e.data())))
                        .toList();

                    if (snapshots.data!.docs.isNotEmpty) {
                      if (DateTime.parse(inst.last.dateTime!)
                              .isBefore(DateTime.now()) &&
                          inst.last.fromAdmin!) {
                        NativeNotify.registerIndieID('1');
                      }
                      return ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            bool isAdmin = inst[index].fromAdmin!;
                            print(scrollController.positions);
                            return ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: [
                                Container(
                                  alignment: !isAdmin
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isAdmin
                                          ? const Color(0xE4879B93)
                                          : const Color(0xB66E8075)),
                                  padding: const EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      bottom: 1,
                                      top: 10,
                                      left: isAdmin ? 40 : 10,
                                      right: isAdmin ? 10 : 40),
                                  child: Text(
                                    '''${inst[index].message}''',
                                    textAlign: isAdmin
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: isAdmin ? 40 : 10,
                                      right: isAdmin ? 10 : 40),
                                  child: Text(
                                    inst[index].dateTime!.split('.')[0],
                                    textAlign: isAdmin
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 8, color: Colors.grey),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('No Instructions'),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )),
          Row(
            children: [
              Expanded(
                flex: 11,
                child: Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                  ),
                  // height: 48,
                  child: Form(
                    key: messageKey,
                    child: TextFormField(
                        // textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        minLines: 1,
                        controller: messageController,
                        // onChanged: onSearchChanged,
                        style: const TextStyle(color: Colors.green),
                        cursorColor: Colors.green,
                        decoration: _searchDecoration(context)),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                    onPressed: () async {
                      if (messageController.text.isNotEmpty) {
                        await CompanyController.instance
                            .sendInstructions(
                                Instruction(
                                    message: messageController.text,
                                    dateTime: DateTime.now().toString(),
                                    fromAdmin: false),
                                compId: companyId,
                                driverId: driverId)
                            .then((value) async {
                          FocusScope.of(context).unfocus();
                          messageController.clear();
                        });
                      } else {
                        messageController.clear();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _searchDecoration(BuildContext context) => InputDecoration(
        hintText: 'Type here  ...',
        counterStyle: Theme.of(context).textTheme.bodyMedium,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        // suffixIcon: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.search,
        //       color: Colors.green,
        //     )),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
        disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
      );
}
