package com.amh.explorer

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

  // override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
  //   super.configureFlutterEngine(flutterEngine)
  //   MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
  // "amh.fileManager.com/video_thumbnail")
  //       .setMethodCallHandler { call, result ->
  //         if (call.method == "handleVideo") {
  //           val filePath = call.argument<String>("filePath")!!
  //           val time = call.argument<Long>("time")!!
  //           val outputPath = call.argument<String>("output")!!
  //           val thumbnail = createThumbnail(filePath, time)!!

  //           saveBitmapToFile(thumbnail, File(outputPath))

  //           // Bitmap thumb = ThumbnailUtils.createVideoThumbnail(call.argument(),
  //           // MediaStore.Images.Thumbnails.MINI_KIND);
  //           result.success(outputPath)
  //         } else {
  //           result.notImplemented()
  //         }
  //       }
  // }

  // fun createThumbnail(videoPath: String, time: Long): Bitmap? {
  //   val retriever = MediaMetadataRetriever()
  //   try {
  //     retriever.setDataSource(videoPath)
  //     return retriever.getFrameAtTime(time)
  //   } catch (e: Exception) {
  //     e.printStackTrace()
  //     return null
  //   } finally {
  //     retriever.release()
  //   }
  // }

  // fun saveBitmapToFile(bitmap: Bitmap, file: File) {
  //   val out = FileOutputStream(file)
  //   try {
  //     bitmap.compress(Bitmap.CompressFormat.JPEG, 10, out)
  //   } finally {
  //     out.close()
  //   }
  // }
}
