List<String> audioExt = [
  '3gp'
      ','
      'aa'
      ','
      'aac'
      ','
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
String getFileTypeIcon(String extension) {
  String ext = extension.toLowerCase().replaceAll('.', '');
  String iconPackFolder = 'assets/ext_icons/icons_1/';
  String extImage = 'unknown';
  //* checking audio
  if (audioExt.contains(ext)) {
    extImage = 'audio';
  } else if (videoExt.contains(ext)) {
    extImage = 'video';
  } else if (imagesExt.contains(ext)) {
    extImage = 'image';
  } else if (ext == 'pdf') {
    extImage = 'pdf';
  }
  return '$iconPackFolder$extImage.png';
}
