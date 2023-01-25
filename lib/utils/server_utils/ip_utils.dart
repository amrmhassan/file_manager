//? get my wifi address
import 'dart:io';

Future<String?> getMyIpAddress([bool wifi = true]) async {
  //! this might change for other devices
  // 192.168.43.99   => wlan0 == mostly wifi
  // 192.168.118.237 => wlan1 == mostly hotspot
  try {
    var interfaces = await NetworkInterface.list();
    var wifiInterface = interfaces.firstWhere((element) =>
        element.name.contains(wifi ? 'wlan0' : 'wlan1') ||
        element.name.contains('wifi'));
    // return null;
    return wifiInterface.addresses.first.address;
  } catch (e) {
    return null;
  }
}
