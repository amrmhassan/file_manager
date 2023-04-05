import 'package:ffi/ffi.dart';
import 'dart:ffi';

import 'package:explorer/utils/general_utils.dart';

typedef SetCursorPosC = Void Function(Int32 x, Int32 y);
typedef SetCursorPosDart = void Function(int x, int y);

typedef GetCursorPosC = Int32 Function(Pointer<Int32> lpPoint);
typedef GetCursorPosDart = int Function(Pointer<Int32> lpPoint);

typedef MouseEventC = Void Function(
    Uint32 dwFlags, Uint32 dx, Uint32 dy, Uint32 dwData, IntPtr dwExtraInfo);
typedef MouseEventDart = void Function(
    int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

//? mouse controller class
class MouseController {
  Position get mousePosition => _getMousePosition();

  DynamicLibrary get _user32 => DynamicLibrary.open('user32.dll');

  dynamic get _mouseEvent =>
      _user32.lookupFunction<MouseEventC, MouseEventDart>('mouse_event');

  void setCursorPosition(int x, int y) {
    printOnDebug('setCursorPosition');
    final SetCursorPosDart setCursorPos = _user32
        .lookup<NativeFunction<SetCursorPosC>>('SetCursorPos')
        .asFunction();

    setCursorPos(x, y); // move mouse to (100, 100)
  }

  void setCursorPositionDelta(int dx, int dy) {
    setCursorPosition(mousePosition.x + dx, mousePosition.y + dy);
  }

  Position _getMousePosition() {
    final GetCursorPosDart getCursorPos = _user32
        .lookup<NativeFunction<GetCursorPosC>>('GetCursorPos')
        .asFunction();

    final coordinatesPointer =
        calloc<Int32>(2); // Allocate memory for two Int32 values
    getCursorPos(
        coordinatesPointer); // Call the function with a pointer to the allocated memory
    final x = coordinatesPointer
        .value; // Read the X coordinate from the allocated memory
    final y = coordinatesPointer
        .elementAt(1)
        .value; // Read the Y coordinate from the allocated memory
    calloc.free(coordinatesPointer); // Free the allocated memory
    return Position(x, y);
  }

  void leftMouseButtonDown() {
    printOnDebug('leftMouseButtonDown');
    // Perform a left mouse button click at the current cursor position
    var currentPosition = mousePosition;
    _mouseEvent(
      0x0002,
      currentPosition.x,
      currentPosition.y,
      0,
      0,
    );
  }

  void leftMouseButtonUp() {
    printOnDebug('leftMouseButtonUp');

    var currentPosition = mousePosition;
    _mouseEvent(
      0x0004,
      currentPosition.x,
      currentPosition.y,
      0,
      0,
    );
  }

  void rightMouseButtonDown() {
    printOnDebug('rightMouseButtonDown');

    var currentPosition = mousePosition;
    _mouseEvent(
      0x0008,
      currentPosition.x,
      currentPosition.y,
      0,
      0,
    );
  }

  void rightMouseButtonUp() {
    printOnDebug('rightMouseButtonUp');

    var currentPosition = mousePosition;
    _mouseEvent(
      0x0010,
      currentPosition.x,
      currentPosition.y,
      0,
      0,
    );
  }
}

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  String toString() {
    return '$x,$y';
  }
}
