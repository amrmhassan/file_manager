package com.amh.file_manager

import androidx.annotation.NonNull
import com.amh.file_manager.helpers.ThumbnailCreator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "amh.fileManager.com/create_thumbnail"
        )
        .setMethodCallHandler { call, result ->
          val filePath = call.argument<String>("filePath")!!
          val outputPath = call.argument<String>("output")!!
          val thumbnailWidth = call.argument<Int>("width")!!
          val tc = ThumbnailCreator(filePath, outputPath, thumbnailWidth)
          thread {
            try {
              if (call.method == "handleVideo") {

                val time = call.argument<Long>("time")!!
                val thumbnailPath = tc.createVideoThumbnail(filePath, time)!!

                result.success(thumbnailPath)
              } else if (call.method == "handleAPK") {
                val pm = getPackageManager()

                val thumbnailPath = tc.createAPKThumnail(filePath, outputPath, pm)

                result.success(thumbnailPath)
              } else if (call.method == "handleImage") {

                val thumbnailPath = tc.createImageThumbnail(filePath)
                result.success(thumbnailPath)
              } else {
                result.notImplemented()
              }
            } catch (e: Exception) {
              result.success(e.toString())
              print("An error occured creating a thumbnail")
            }
          }
        }
  }
}
