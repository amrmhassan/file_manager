//? get my wifi address
import 'dart:io';

Future<String?> getMyIpAddress([bool wifi = true]) async {
  //! this might change for other devices
  // 192.168.43.99   => wlan0 == mostly wifi
  // 192.168.118.237 => wlan1 == mostly hotspot
  try {
    var interfaces = await NetworkInterface.list();
    print(interfaces);
    var wifiInterface = interfaces.firstWhere(
        (element) => element.name.contains(wifi ? 'wlan0' : 'wlan1'));
    // return null;
    return wifiInterface.addresses
        .firstWhere((element) => element.address.startsWith('192.'))
        .address;
  } catch (e) {
    return null;
  }
}
