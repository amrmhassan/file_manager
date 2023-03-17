import 'package:explorer/main.dart';

class ForegroundServiceController {
  bool _connectLaptopServerRunning = false;
  bool _shareSpaceServerRunning = false;
  bool _running = false;

  bool get _doStopIt =>
      !_connectLaptopServerRunning && !_shareSpaceServerRunning;

  void _startForegroundService() {
    if (_running) return;
    startForegroundService();
    _running = true;
  }

  void _stopForegroundService() {
    if (!_running) return;
    if (!_doStopIt) return;
    stopForegroundService();
    _running = false;
  }

  void shareSpaceServerStarted() {
    _shareSpaceServerRunning = true;
    _startForegroundService();
  }

  void connPhoneServerStarted() {
    _connectLaptopServerRunning = true;
    _startForegroundService();
  }

  void shareSpaceServerStopped() {
    _shareSpaceServerRunning = false;
    _stopForegroundService();
  }

  void connPhoneServerStopped() {
    _connectLaptopServerRunning = false;
    _stopForegroundService();
  }
}
