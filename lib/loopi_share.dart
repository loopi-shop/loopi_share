import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class LoopiShare {
  static const MethodChannel _channel = const MethodChannel('loopi_share');

  static Future<String?> shareInstagram({
    required String videoPath,
    required String stickerPath,
    String? clibBoardIos,
  }) async {
    Map<String, String> args = {
      "videoPath": videoPath,
      "stickerPath": stickerPath,
    };

    if (Platform.isIOS) {
      args.addAll({
        "clipBoard": clibBoardIos ?? "",
      });
    }

    return _channel.invokeMethod(
      'shareInstagramImageStoryWithSticker',
      args,
    );
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
