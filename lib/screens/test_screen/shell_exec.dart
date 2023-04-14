// import 'dart:ffi';
// import 'dart:io';
// import 'package:ffi/ffi.dart';

// typedef _ShellExecute = IntPtr Function(
//     IntPtr hwnd,
//     Pointer<Utf8> lpOperation,
//     Pointer<Utf8> lpFile,
//     Pointer<Utf8> lpParameters,
//     Pointer<Utf8> lpDirectory,
//     Int32 nShowCmd);

// final shell32 = DynamicLibrary.open('Shell32.dll');
// final shellExecute =
//     shell32.lookupFunction<_ShellExecute, _ShellExecute>('ShellExecuteA');

// void runAsAdmin(String command) {
//   final hwnd = nullptr;
//   final lpOperation = Utf8.toUtf8('runas');
//   final lpFile = Utf8.toUtf8('cmd.exe');
//   final lpParameters = Utf8.toUtf8('/c $command');
//   final lpDirectory = Utf8.toUtf8(Directory.current.path);
//   final nShowCmd = 1; // SW_SHOWNORMAL
//   shellExecute(hwnd, lpOperation, lpFile, lpParameters, lpDirectory, nShowCmd);
//   free(lpOperation);
//   free(lpFile);
//   free(lpParameters);
//   free(lpDirectory);
// }
