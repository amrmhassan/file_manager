package com.amh.file_manager

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.media.MediaMetadataRetriever
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "amh.fileManager.com/video_thumbnail")
        .setMethodCallHandler { call, result ->
          thread {
            print("message")
            // try {
            if (call.method == "handleVideo") {
              val filePath = call.argument<String>("filePath")!!
              val time = call.argument<Long>("time")!!
              val outputPath = call.argument<String>("output")!!
              val thumbnail = createThumbnail(filePath, time)!!

              saveBitmapToFile(thumbnail, File(outputPath))

              result.success(outputPath)
            } else if (call.method == "handleAPK") {

              // ? here the code to make an apk file thumbnail
              val filePath = call.argument<String>("filePath")!!
              val outputPath = call.argument<String>("output")!!

              val thumbnail = makeAPKIcon(filePath, outputPath)
              result.success(thumbnail)
            } else {
              result.notImplemented()
            }
            // } catch (e: Exception) {
            //   print("An error occured creating video thumbnail")
            // }
          }
        }
  }

  fun createThumbnail(videoPath: String, time: Long): Bitmap? {
    val retriever = MediaMetadataRetriever()
    try {
      retriever.setDataSource(videoPath)
      return retriever.getFrameAtTime(time)
    } catch (e: Exception) {
      e.printStackTrace()
      return null
    } finally {
      retriever.release()
    }
  }

  fun saveBitmapToFile(bitmap: Bitmap, file: File) {
    val out = FileOutputStream(file)
    try {
      bitmap.compress(Bitmap.CompressFormat.JPEG, 20, out)
    } finally {
      out.close()
    }
  }

  fun makeAPKIcon(apkFilePath: String, outputFile: String): String {

    val pm = getPackageManager()
    val pi = pm.getPackageArchiveInfo(apkFilePath, 0)

    // the secret are these two lines....
    pi!!.applicationInfo.sourceDir = apkFilePath
    pi.applicationInfo.publicSourceDir = apkFilePath
    //

    val apkicon = pi.applicationInfo.loadIcon(pm)!!
    // val appName = pi.applicationInfo.loadLabel(pm)
    val thumbPath = drawableToBitmap(apkicon, outputFile)
    return thumbPath
  }

  fun drawableToBitmap(drawable: Drawable, outputFile: String): String {
    val bitmap =
        Bitmap.createBitmap(
            drawable.intrinsicWidth,
            drawable.intrinsicHeight,
            Bitmap.Config.ARGB_8888
        )
    bitmap.eraseColor(Color.TRANSPARENT)
    val canvas = Canvas(bitmap)
    drawable.setBounds(0, 0, canvas.width, canvas.height)
    drawable.draw(canvas)
    val file = File(outputFile)
    saveBitmapToFile(bitmap, file)

    return file.path
  }
}
