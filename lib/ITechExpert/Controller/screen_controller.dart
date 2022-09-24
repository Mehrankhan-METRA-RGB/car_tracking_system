import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';


class ScreenController {
  late final Uint8List _imageBytes;
  Uint8List get imageBytes => _imageBytes;
  final File _path = File('');
  File get path => _path;

  Future<Uint8List?> capturePng(
    GlobalKey widgetKey,
  ) async {
    Uint8List? data;
    RenderRepaintBoundary? boundary =
        widgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    ui.Image? image = await boundary?.toImage(pixelRatio: 2);

    await image?.toByteData(format: ui.ImageByteFormat.png).then((val) {
      data= val?.buffer.asUint8List();
    });
    if (kDebugMode) {
      print(data);
    }
    return data;
  }


  Future <Uint8List> takeImageBytes(String imgPath)async {
    ByteData byteData = await rootBundle.load('assets/itech/$imgPath');
if (kDebugMode) {
  print(byteData.buffer.asUint8List());
}
  return byteData.buffer.asUint8List();
  }
  Future saveImage(Uint8List bytes) async {
    try {
      final directory = await getExternalStorageDirectory();
      final myImagePath =
          '${directory?.parent.parent.parent.parent.path}/Pictures';
      final myImgDir = await Directory(myImagePath).create();

      File file =
          File("${myImgDir.path}/image_${Random().nextInt(190902)}.png");
      file.writeAsBytes(bytes);
    } catch (e) {
      if (kDebugMode) {
        print('eeeeeeeeeeee:$e');
      }
    }
  }
}
