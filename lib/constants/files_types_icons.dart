import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';

enum FileType {
  image,
  video,
  audio,
  batch,
  archive,
  docs,
  unknown,
  apk,
  word,
  excel,
  powerPoint,
  text,
  folder,
}

List<String> docsExt = [
  'pdf',
  'txt',
  'xls',
  'xlsx',
  'doc',
  'docx',
  'ppt',
  'pptx',
  'ods',
  'odt',
  'htm',
  'html',
];

List<String> audioExt = [
  '3gp',
  'aa',
  'aac',
  'aax',
  'act',
  'aiff',
  'alac',
  'amr',
  'ape',
  'au',
  'awb',
  'dss',
  'dvf',
  'flac',
  'gsm',
  'iklax',
  'ivs',
  'm4a',
  'm4b',
  'm4p',
  'mmf',
  'mp3',
  'mpc',
  'msv',
  'nmf',
  'ogg',
  'oga',
  'mogg',
  'opus',
  'ra',
  'rm',
  'raw',
  'rf64',
  'sln',
  'tta',
  'voc',
  'wav',
  'wma',
  'wv',
  'webm',
  '8svx',
  'cda',
];

List<String> videoExt = [
  'webm',
  'mkv',
  'flv',
  'vob',
  'ogv',
  'gif',
  'gifv',
  'mng',
  'avi',
  'ts',
  'mts',
  'm2ts',
  'mov',
  'qt',
  'wmv',
  'yuv',
  'rm',
  'rmvb',
  'viv',
  'asf',
  'amv',
  'mp4',
  'm4p',
  'm4v',
  'mpg',
  'mp2',
  'mpeg',
  'mpe',
  'mpv',
  'svi',
  '3gp',
  '3g2',
  'mxf',
  'roq',
  'nsv',
  'flv',
  'f4v',
  'f4p',
  'f4a',
  'f4b',
];

List<String> imagesExt = [
  'jpeg',
  'heif',
  'png',
  'gif',
  'svg',
  'eps',
  'tiff',
  'jpg'
];

List<String> batchFilesExt = [
  'bat',
  'batch',
  'sh',
  'su',
  'zsh',
  'bash',
  'dash',
];

List<String> archivesExt = [
  'zip',
  'tar',
  'rar',
  'iso',
];

List<String> excelsExt = [
  'xls',
  'xlsx',
  'xlsm',
  'xltx',
  'xltm',
  'xlsb',
  'csv',
];
List<String> wordExt = [
  'doc',
  'docx',
  'docm',
  'dotx',
  'dotm',
];
List<String> powerPointExt = [
  'ppt',
  'pptx',
  'pptm',
  'potx',
  'potm',
];
List<String> textExt = [
  'txt',
  'log',
  'conf',
  'asc',
];
List<String> richTextExt = [
  'rtf',
];

FileType getFileTypeFromPath(String filePath) {
  String ext = getFileExtension(filePath);
  return getFileType(ext);
}

//? this if to get the file type in general and have no relationship with file icon
FileType getFileType(String fileExt) {
  String ext = fileExt.toLowerCase().replaceAll('.', '');

  if (audioExt.contains(ext)) {
    return FileType.audio;
  } else if (videoExt.contains(ext)) {
    return FileType.video;
  } else if (imagesExt.contains(ext)) {
    return FileType.image;
  } else if (archivesExt.contains(ext)) {
    return FileType.archive;
  } else if (batchFilesExt.contains(ext)) {
    return FileType.batch;
  } else if (ext == 'apk') {
    return FileType.apk;
  } else if (docsExt.contains(ext)) {
    return FileType.docs;
  } else {
    return FileType.unknown;
  }
}

//! investigate about svg file extension

//? this is only to get file icon path
String getFileTypeIcon(String fileExtension) {
  // here you need to check the specific file extensions first before the general ones,
  // for example check the word, excel, text extensions before the docs ones
  String ext = fileExtension.toLowerCase().replaceAll('.', '');
  String iconPackFolder = 'assets/ext_icons/icons_1/';
  String extImage = 'unknown';
  //* checking audio
  if (excelsExt.contains(ext)) {
    extImage = 'xls';
  } else if (wordExt.contains(ext)) {
    extImage = 'doc';
  } else if (powerPointExt.contains(ext)) {
    extImage = 'pptx';
  } else if (textExt.contains(ext)) {
    extImage = 'text';
  } else if (richTextExt.contains(ext)) {
    extImage = 'text-rtf';
  } else if (audioExt.contains(ext)) {
    extImage = 'audio';
  } else if (videoExt.contains(ext)) {
    extImage = 'video';
  } else if (imagesExt.contains(ext)) {
    extImage = 'image';
  } else if (ext == 'pdf') {
    extImage = 'pdf';
  } else if (ext == 'apk') {
    extImage = 'apk';
  } else if (batchFilesExt.contains(ext)) {
    extImage = 'shellscript';
  } else if (ext == 'exe') {
    extImage = 'exec';
  } else if (archivesExt.contains(ext)) {
    extImage = 'tar';
  } else {
    String? programmingLanguageExtension = getProgrammingFileIcon(ext);
    if (programmingLanguageExtension != null) {
      extImage = programmingLanguageExtension;
    }
  }
  return '$iconPackFolder$extImage.png';
}

//? to recognize extensions for programming languages
String? getProgrammingFileIcon(String ext) {
  // i will use this function in the above method for abstraction
  // it will be used just before returning that it is unknown because not many people will be interested in programming languages files
  String? extImage;
  if (ext == 'py') {
    extImage = 'text-x-py';
  } else if (ext == 'java') {
    extImage = 'text-x-java';
  } else if (ext == 'c') {
    extImage = 'text-x-c';
  } else if (ext == 'cpp' || ext == 'cc' || ext == 'cxx') {
    extImage = 'text-x-cpp';
  } else if (ext == 'js') {
    extImage = 'text-x-js';
  } else if (ext == 'php') {
    extImage = 'text-x-php';
  } else if (ext == 'ts') {
    extImage = 'text-x-ts';
  } else if (ext == 'html' || ext == 'htm') {
    extImage = 'text-x-html';
  } else if (ext == 'xml') {
    extImage = 'text-x-xml';
  } else if (ext == 'css') {
    extImage = 'text-x-css';
  }
  return extImage;
}


// C: .c
// C++: .cpp, .cc, .cxx
// C#: .cs
// Java: .java
// Python: .py
// Ruby: .rb
// Swift: .swift
// JavaScript: .js
// PHP: .php
// Go: .go
// Rust: .rs
// Kotlin: .kt
// TypeScript: .ts
// Lua: .lua


// XML: xml
// HTML: html, htm
// CSS: css,