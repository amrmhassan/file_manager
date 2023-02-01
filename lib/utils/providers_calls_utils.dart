import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? server provider
ServerProvider serverPF(BuildContext context) {
  return Provider.of<ServerProvider>(context, listen: false);
}

ServerProvider serverP(BuildContext context) {
  return Provider.of<ServerProvider>(context);
}

//? share provider

ShareProvider sharePF(BuildContext context) {
  return Provider.of<ShareProvider>(context, listen: false);
}

ShareProvider shareP(BuildContext context) {
  return Provider.of<ShareProvider>(context);
}
