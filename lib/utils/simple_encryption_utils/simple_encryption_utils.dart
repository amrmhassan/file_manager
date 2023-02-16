import 'dart:math';

class SimpleEncryption {
  String msg;
  SimpleEncryption(this.msg);
  final String _alpha = 'abcdefghijklmnopqrstuvwxyz0123456789.|:';

// margin =3
// 0 1 2 3 4 5 6 7 8 9
// 3 4 5 6 7 8 9 0 1 2
  late List<String> _letters;
  late List<String> _mappedLetters;
  late int _margin;

  void _setMappedLetters() {
    List<String> res = [];
    int newIndex = 0;
    // if margin ==1
    // 0=>1
    for (var i = _margin; i < _letters.length + _margin; i++) {
      newIndex = i;
      if (newIndex >= _letters.length) {
        newIndex -= _letters.length;
      }
      res.add(_letters[newIndex]);
    }
    _mappedLetters = res;
  }

  String _getEquivalentLetter(String letter, [bool reverse = false]) {
    late String mappedLetter;
    if (reverse) {
      int index = _mappedLetters.indexOf(letter);
      mappedLetter = _letters[index];
    } else {
      int index = _letters.indexOf(letter);
      mappedLetter = _mappedLetters[index];
    }

    return mappedLetter;
  }

  int _randomNumber() {
    return (Random().nextInt(_alpha.length - 1) + 1);
  }

  String encrypt() {
    // the encrypted message will contain the margin at the first letter so it should be from 1 to 9
    _margin = _randomNumber();
    _letters = _alpha.split('');
    _setMappedLetters();
    var res = msg.split('').fold(
        '',
        (previousValue, element) =>
            previousValue + _getEquivalentLetter(element));
    res += ' $_margin';

    return res;
  }

  String decrypt() {
    List<String> data = msg.split(' ');
    msg = data.first;
    _margin = int.parse(data.last);
    _letters = _alpha.split('');
    _setMappedLetters();
    var res = msg.split('').fold(
        '',
        (previousValue, element) =>
            previousValue + _getEquivalentLetter(element, true));
    return res;
  }
}
