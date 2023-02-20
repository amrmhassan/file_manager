//? get my wifi address
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/utils/simple_encryption_utils/simple_encryption_utils.dart';

Future<String?> getMyIpAddress([bool wifi = true]) async {
  //! this might change for other devices
  // 192.168.43.99   => wlan0 == mostly wifi
  // 192.168.118.237 => wlan1 == mostly hotspot
  try {
    //! use type: InternetAddressType.IPv4, leave 192 thing because other devices like emulators uses ipv4 with 0.0.0.0 networks
    var interfaces = await NetworkInterface.list();
    String wifiString = Platform.isWindows ? 'wi-fi' : 'wlan0';
    var wifiInterface = interfaces.firstWhere(
      (element) =>
          element.name.toLowerCase().contains(wifi ? wifiString : 'wlan1'),
    );
    // return null;
    return wifiInterface.addresses
        .firstWhere((element) => element.address.startsWith('192.'))
        .address;
  } catch (e) {
    return null;
  }
}

Future<Iterable<String>?> getPossibleIpAddress() async {
  try {
    var interfaces =
        await NetworkInterface.list(type: InternetAddressType.IPv4);
    logger.i('I have ${interfaces.length} interfaces');
    var res = interfaces.map((e) => e.addresses.first.address);
    return res;
  } catch (e) {
    return null;
  }
}

String connLinkQrFromIterable(Iterable<String> ips, int port) {
  String res = "${ips.map((e) => e).join('|')}||$port";
  String encrypted = SimpleEncryption(res).encrypt();

  return encrypted;
}
