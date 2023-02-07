String durationFloatToString(int n, [bool zero = true]) {
  if (!zero) return '$n';
  if (n < 10) return '0$n';
  return '$n';
}

String durationToString(Duration? d) {
  if (d == null) return '';
  int hours = d.inHours;
  if (hours > 0) {
    int minutes = Duration(minutes: d.inMinutes - hours * 60).inMinutes;
    int seconds =
        Duration(seconds: d.inSeconds - minutes * 60 - hours * 3600).inSeconds;
    return '$hours:${durationFloatToString(minutes)}:${durationFloatToString(seconds)}';
  } else {
    int minutes = d.inMinutes;
    int seconds = Duration(seconds: d.inSeconds - minutes * 60).inSeconds;
    return '${durationFloatToString(minutes)}:${durationFloatToString(seconds)}';
  }
}
