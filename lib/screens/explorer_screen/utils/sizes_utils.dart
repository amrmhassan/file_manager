import 'package:explorer/utils/general_utils.dart';

double getSizePercentage(int size, int parentSize) {
  if (parentSize == 0) return 0;
  return ((size) / parentSize) * 1;
}

//? update this to be readable
String sizePercentageString(double percentage) {
  return '${doubleToString(percentage * 100)}%';
}
