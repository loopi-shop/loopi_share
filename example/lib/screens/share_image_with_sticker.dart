import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopi_share/loopi_share.dart';

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
