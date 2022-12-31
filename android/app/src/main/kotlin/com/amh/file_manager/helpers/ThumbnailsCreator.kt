package com.amh.file_manager.helpers

import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.media.MediaMetadataRetriever
import java.io.File
import java.io.FileOutputStream

class ThumbnailCreator(var filePath: String, var outputPath: String, var thumbnailWidth: Int) {

  // ? to  make an image thumbnail
  fun createImageThumbnail(imagePath: String): String {
    this.saveBitmapToFile(BitmapFactory.decodeFile(imagePath), File(outputPath), thumbnailWidth)
    return outputPath
  }
  // ? to create a video thumbnail
  fun createVideoThumbnail(videoPath: String, time: Long): String? {
    val retriever = MediaMetadataRetriever()
    try {
      retriever.setDataSource(videoPath)
      val bitmap = retriever.getFrameAtTime(time)!!
      this.saveBitmapToFile(bitmap, File(outputPath), thumbnailWidth)
      return outputPath
    } catch (e: Exception) {
      e.printStackTrace()
      return null
    } finally {
      retriever.release()
    }
  }

  // ? to make an apk icon
  fun createAPKThumnail(apkFilePath: String, outputFile: String, pm: PackageManager): String {

    val pi = pm.getPackageArchiveInfo(apkFilePath, 0)

    // to set the object to the wanted apk file
    pi!!.applicationInfo.sourceDir = apkFilePath
    pi.applicationInfo.publicSourceDir = apkFilePath
    //

    val apkicon = pi.applicationInfo.loadIcon(pm)!!
    // val appName = pi.applicationInfo.loadLabel(pm)
    val thumbPath = this.drawableToBitmap(apkicon, outputFile, thumbnailWidth)
    return thumbPath
  }

  // ? to save a bitmap to a file
  private fun saveBitmapToFile(bitmap: Bitmap, file: File, newWidth: Int) {
    val out = FileOutputStream(file)
    try {

      val originalWidth = bitmap.width
      val originalHeight = bitmap.height
      val compressFactor = (originalWidth * 1.0) / (newWidth * 1.0)
      val newHeight = originalHeight / compressFactor
      val newWidthCalced = originalWidth / compressFactor

      val scaledBitmap =
          Bitmap.createScaledBitmap(bitmap, newWidthCalced.toInt(), newHeight.toInt(), false)
      scaledBitmap.compress(Bitmap.CompressFormat.PNG, 15, out)
    } finally {
      out.close()
    }
  }

  // ? to convert drawble to bitmap (needed in the apk thumbnails)
  private fun drawableToBitmap(drawable: Drawable, outputFile: String, width: Int): String {
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
    this.saveBitmapToFile(bitmap, file, width)

    return file.path
  }
}
