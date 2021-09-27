import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

enum LoopiShareType {
  image,
  video,
}

class LoopiShare {
  static const MethodChannel _channel = const MethodChannel('loopi_share');

  static shareInstagram({
    required String videoPath,
    required String stickerPath,
    required LoopiShareType shareType,
    String? attributionURL,
    String? backgroundTopColor,
    String? backgroundBottomColor,
  }) async {
    if (Platform.isAndroid) {
      Map<String, String> args = {
        "backgroundPath": videoPath,
        "stickerPath": stickerPath,
      };
      if (attributionURL != null) {
        args.addAll(
          {"attributionURL": attributionURL},
        );
      }

      if (backgroundTopColor != null) {
        args.addAll(
          {"backgroundTopColor": backgroundTopColor},
        );
      }

      if (backgroundBottomColor != null) {
        args.addAll(
          {"backgroundTopColor": backgroundBottomColor},
        );
      }

      if (shareType == LoopiShareType.image) {
        return _channel.invokeMethod(
          'shareInstagramImageStoryWithSticker',
          args,
        );
      }
    }
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
