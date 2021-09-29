import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopi_share/loopi_share.dart';

void main() {
  runApp(MaterialApp(
    title: "App",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await LoopiShare.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Running on: $_platformVersion\n'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShareImageWithSticker(),
                ),
              );
            },
            child: Text("Share image with Sticker"),
          ),
        ],
      ),
    );
  }
}

class ShareImageWithSticker extends StatelessWidget {
  const ShareImageWithSticker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? backgroundVideo;
    PickedFile? stickerImage;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Share Image Instagram With Sticker",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                backgroundVideo = await imagePicker.getVideo(
                  source: ImageSource.gallery,
                );
              },
              child: Text("Get Video"),
            ),
            ElevatedButton(
              onPressed: () async {
                stickerImage = await imagePicker.getImage(
                  source: ImageSource.gallery,
                );
              },
              child: Text("Image Sticker"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (backgroundVideo != null && stickerImage != null) {
                  String? result = await LoopiShare.shareInstagram(
                    videoPath: backgroundVideo!.path,
                    stickerPath: stickerImage!.path,
                  );
                  print(result);
                }
              },
              child: Text("Send to Instagram"),
            ),
          ],
        ),
      ),
    );
  }
}
