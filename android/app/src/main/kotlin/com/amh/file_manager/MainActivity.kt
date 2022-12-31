package com.amh.file_manager

import android.graphics.Bitmap
import android.graphics.BitmapFactory
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
    MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "amh.fileManager.com/create_thumbnail"
        )
        .setMethodCallHandler { call, result ->
          thread {
            print("message")
            try {
              if (call.method == "handleVideo") {

                val filePath = call.argument<String>("filePath")!!
                val time = call.argument<Long>("time")!!
                val outputPath = call.argument<String>("output")!!
                val thumbnailWidth = call.argument<Int>("width")!!
                val thumbnail = createVideoThumbnail(filePath, time)!!
                saveBitmapToFile(thumbnail, File(outputPath), thumbnailWidth)
                result.success(outputPath)
              } else if (call.method == "handleAPK") {

                val filePath = call.argument<String>("filePath")!!
                val outputPath = call.argument<String>("output")!!
                val thumbnailWidth = call.argument<Int>("width")!!
                val thumbnail = makeAPKIcon(filePath, outputPath, thumbnailWidth)
                result.success(thumbnail)
              } else if (call.method == "handleImage") {

                val filePath = call.argument<String>("filePath")!!
                val outputPath = call.argument<String>("output")!!
                val thumbnailWidth = call.argument<Int>("width")!!

                makeImageThumbnail(filePath, outputPath, thumbnailWidth)
                result.success(outputPath)
              } else {
                result.notImplemented()
              }
            } catch (e: Exception) {
              print("An error occured creating a thumbnail")
            }
          }
        }
  }

  // ? to create a video thumbnail
  fun createVideoThumbnail(videoPath: String, time: Long): Bitmap? {
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

  // ? to save a bitmap to a file
  fun saveBitmapToFile(bitmap: Bitmap, file: File, newWidth: Int) {
    val out = FileOutputStream(file)
    try {

      val originalWidth = bitmap.width
      val originalHeight = bitmap.height
      val compressFactor = (originalWidth * 1.0) / (newWidth * 1.0)
      val newHeight = originalHeight / compressFactor
      val newWidthCalced = originalWidth / compressFactor

      val scaledBitmap =
          Bitmap.createScaledBitmap(bitmap, newWidthCalced.toInt(), newHeight.toInt(), false)
      scaledBitmap.compress(Bitmap.CompressFormat.PNG, 20, out)
    } finally {
      out.close()
    }
  }

  // ? to make an apk icon
  fun makeAPKIcon(apkFilePath: String, outputFile: String, width: Int): String {
    val pm = getPackageManager()
    val pi = pm.getPackageArchiveInfo(apkFilePath, 0)

    // to set the object to the wanted apk file
    pi!!.applicationInfo.sourceDir = apkFilePath
    pi.applicationInfo.publicSourceDir = apkFilePath
    //

    val apkicon = pi.applicationInfo.loadIcon(pm)!!
    // val appName = pi.applicationInfo.loadLabel(pm)
    val thumbPath = drawableToBitmap(apkicon, outputFile, width)
    return thumbPath
  }

  // ? to convert drawble to bitmap (needed in the apk thumbnails)
  fun drawableToBitmap(drawable: Drawable, outputFile: String, width: Int): String {
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
    saveBitmapToFile(bitmap, file, width)

    return file.path
  }

  // ? to  make an image thumbnail
  fun makeImageThumbnail(imagePath: String, outputFile: String, width: Int) {
    saveBitmapToFile(BitmapFactory.decodeFile(imagePath), File(outputFile), width)
  }
}
