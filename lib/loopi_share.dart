import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class LoopiShare {
  static const MethodChannel _channel = const MethodChannel('loopi_share');

  static shareInstagram({
    required String videoPath,
    required String stickerPath,
  }) async {
    if (Platform.isAndroid) {
      Map<String, String> args = {
        "backgroundPath": videoPath,
        "stickerPath": stickerPath,
      };

      return _channel.invokeMethod(
        'shareInstagramImageStoryWithSticker',
        args,
      );
    }
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
