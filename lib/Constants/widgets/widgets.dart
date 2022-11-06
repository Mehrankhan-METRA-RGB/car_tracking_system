import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:smart_select/smart_select.dart';

class App {
  App._private();
  static final instance = App._private();

  ///Application SnackBar
  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> snackBar(
      BuildContext context,
      {String? text,
      Color? bgColor,
      TextStyle? textStyle}) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text!,
        style: textStyle ?? Theme.of(context).snackBarTheme.contentTextStyle,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      duration: const Duration(seconds: 2),
      backgroundColor:
          bgColor ?? Theme.of(context).snackBarTheme.backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: Theme.of(context).snackBarTheme.shape,
    ));
  }

  ///Application Button
  button(
    BuildContext context, {
    required Widget child,
    double hPadding = 20,
    double vPadding = 2,
    required void Function()? onPressed,
    Color? color,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        child: CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          onPressed: onPressed,
          color: color ?? Theme.of(context).buttonTheme.colorScheme!.background,
        ),
      );

  dropDown(
      {required List<String>? values,
      required List<String>? titles,
      String heading = "title",
      String placeholder = 'select',
      double? paddingVert = 25,
      dynamic controller}) {
    // simple usage
    if (values!.length != titles!.length) {
      throw "The length of values and titles must be same";
    }
  }
  //
  //   List<S2Choice<String>> options = [
  //     for (var i = 0; i < values.length; i++)
  //       S2Choice<String>(value: values[i], title: titles[i]),
  //   ];
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: paddingVert!),
  //     child: SmartSelect<String>.single(
  //         placeholder: placeholder,
  //         title: heading,
  //         value: controller?.choiceData.value ?? 'not selected',
  //         choiceItems: options,
  //         onChange: (state) {
  //           controller.val(state.value);
  //         },
  //         modalValidation: (val) {
  //           if (val.isEmpty) {
  //             return "Please $heading";
  //           } else {
  //             return null;
  //           }
  //         }),
  //   );
  // }

  /// PopupMenuItem(
  /// child: Text("First"),
  /// value: "first",
  /// ),
 Widget menu(
      {required List<PopupMenuEntry> items,
      void Function(dynamic)? onSelected,
      IconData? icon,
      double? iconSize,
      Color? iconColor}) {
    return PopupMenuButton(
        iconSize: iconSize ?? 18,
        icon: Icon(
          icon ?? Icons.more_vert,
          color: iconColor ?? Colors.black87,
        ),
        padding: const EdgeInsets.all(4),
        color: Colors.white,
        elevation: 20,
        enabled: true,
        onSelected: onSelected,
        itemBuilder: (context) => items);
  }

  dialog(BuildContext context,
      {required Widget child,
      double radius = 12,
      double elevation = 4,
      Color? bgColor,
      bool clickOutSideClose = true,
      AlignmentGeometry? alignment,
      EdgeInsets? insetsPadding,
      Curve curve = Curves.decelerate,

      /// [insetAnimationDuration] count unit is Milli Seconds
      int insetAnimationDuration = 100}) {
    Dialog _dialog = Dialog(
      backgroundColor: bgColor ?? Theme.of(context).cardColor,
      elevation: elevation,
      alignment: alignment,
      insetPadding: insetsPadding,
      insetAnimationCurve: curve,
      insetAnimationDuration: Duration(milliseconds: insetAnimationDuration),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius)), //this right here
      child: child,
    );
    showDialog(
        context: context,
        barrierDismissible: clickOutSideClose,
        builder: (BuildContext context) => _dialog);
  }
}
