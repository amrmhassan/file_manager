package com.amh.file_manager


import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class QuickSendActivity : FlutterActivity() {
  private val CHANNEL = "app.channel.shared.data"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine)
    // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    //     .setMethodCallHandler { call, result ->
    //       if (call.method == "getSharedData") {
    //         // val sharedData = getSharedData<String?>()
    //         if (true) {
    //           result.success("sharedData")
    //         } else {
    //           result.error("UNAVAILABLE", "Shared data not available", null)
    //         }
    //       } else {
    //         result.notImplemented()
    //       }
    //     }
  }

  // private fun getSharedData(): Map<String, Any>? {
  //   return if (intent.action == Intent.ACTION_SEND && intent.type != null) {
  //     if ("text/plain" == intent.type) {
  //       val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
  //       val data = HashMap<String, Any>()
  //       data["text"] = sharedText
  //       data
  //     } else if (intent.type!!.startsWith("image/")) {
  //       val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
  //       val data = HashMap<String, Any>()
  //       data["uri"] = uri.toString()
  //       data
  //     } else {
  //       null
  //     }
  //   } else {
  //     null
  //   }
  // }
}
