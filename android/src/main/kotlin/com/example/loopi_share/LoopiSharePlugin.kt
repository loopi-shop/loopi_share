package com.example.loopi_share

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.net.Uri
import android.content.Intent
import android.content.Context

import android.util.Log   

import java.io.File;
import androidx.core.content.FileProvider;


/** LoopiSharePlugin */
class LoopiSharePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "loopi_share")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "shareInstagramImageStoryWithSticker") {
      val videoPath: String? = call.argument("backgroundPath")
      val stickerPath: String? = call.argument("stickerPath")
      

      val file = File(videoPath!!)
      val fileUri = FileProvider.getUriForFile(
                    context,
                    context.packageName.toString() + ".provider",
                    file
                )

    Log.e(">>>>>>>>>>>>>>> Caiu aqui", fileUri.path!!)

      val file2 = File(stickerPath!!)
      val stickerUri = FileProvider.getUriForFile(
                    context,
                    context.packageName.toString() + ".provider",
                    file2
                )
      
      Log.e(">>>>>>>>>>>>>>> Caiu aqui", stickerUri.path!!)

      if(fileUri != null){
        //stories(Uri.parse("content://media/external/images/media/56"))
        //stories(Uri.parse("content://com.android.providers.media.documents/document/image%3A40"))
        
        stories(fileUri, stickerUri)
      }
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else{
       result.notImplemented()
    }
  }

  //private fun stories(selectedImageUri: Uri){
  private fun stories(urlVideo: Uri, uriSticker: Uri){
      Log.e(">>>>>>>>>>>>>>> Caiu aqui", ">>>>>>>>>>>>>>> Caiu aqui")

      val storiesIntent = Intent("com.instagram.share.ADD_TO_STORY").apply {
          //type = "image/jpeg"
          addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
          addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
          setPackage("com.instagram.android")
          setDataAndType(urlVideo, "video/*")
          putExtra("interactive_asset_uri", uriSticker)
          putExtra("content_url", "something");
          putExtra("top_background_color", "#33FF33")
          putExtra("bottom_background_color", "#FF00FF")
      }

      context.grantUriPermission("com.instagram.android", uriSticker, Intent.FLAG_GRANT_READ_URI_PERMISSION)
      context.startActivity(storiesIntent)
  }

  // private fun stories(selectedImageUri: Uri){
  //     Log.e(">>>>>>>>>>>>>>> Caiu aqui", ">>>>>>>>>>>>>>> Vai enviar image")

  //     val storiesIntent = Intent("com.instagram.share.ADD_TO_STORY").apply {
  //           type = "image/jpeg"
  //           addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
  //           addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
  //           setPackage("com.instagram.android")
  //           setDataAndType(selectedImageUri, "image/jpeg")
  //           putExtra("interactive_asset_uri", selectedImageUri)
  //           putExtra("content_url", "https://instagram-test.free.beeceptor.com");
  //           putExtra("top_background_color", "#33FF33")
  //           putExtra("bottom_background_color", "#FF00FF")
  //       }

  //     context.grantUriPermission("com.instagram.android", selectedImageUri, Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
  //     context.startActivity(storiesIntent)
  // }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
