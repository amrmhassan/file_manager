double getSizePercentage(int size, int parentSize) {
  return ((size) / parentSize) * 1;
}

//? update this to be readable
String sizePercentagleString(double percentage) {
  return '${(percentage * 100).toStringAsFixed(2)}%';
}
