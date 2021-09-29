package com.example.loopi_share

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File


/** LoopiSharePlugin */
class LoopiSharePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "loopi_share")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
            return
        }

        if (call.method == "shareInstagramImageStoryWithSticker") {

            val videoPath: String? = call.argument("videoPath")
            val stickerPath: String? = call.argument("stickerPath")

            if (videoPath != null && stickerPath != null) {
                val videoUri = getUri(videoPath)
                val stickerUri = getUri(stickerPath)
                shareInstagramImageStoryWithSticker(videoUri, stickerUri)

                result.success("Send video and sticker with success")
                return
            }
        }

        result.notImplemented()
        return
    }

    private fun getUri(filePath: String): Uri {
        val file = File(filePath)
        return FileProvider.getUriForFile(
            context,
            context.packageName.toString() + ".provider",
            file
        )
    }

    private fun shareInstagramImageStoryWithSticker(urlVideo: Uri, uriSticker: Uri) {

        val storiesIntent = Intent("com.instagram.share.ADD_TO_STORY").apply {
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            setPackage("com.instagram.android")
            setDataAndType(urlVideo, "video/*")
            putExtra("interactive_asset_uri", uriSticker)
            putExtra("content_url", "something");
            putExtra("top_background_color", "#33FF33")
            putExtra("bottom_background_color", "#FF00FF")
        }

        context.grantUriPermission(
            "com.instagram.android",
            uriSticker,
            Intent.FLAG_GRANT_READ_URI_PERMISSION
        )
        context.startActivity(storiesIntent)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
