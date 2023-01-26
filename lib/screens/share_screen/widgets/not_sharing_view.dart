// ignore_for_file: prefer_const_constructors

import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/share_screen/widgets/empty_share_items.dart';
import 'package:explorer/screens/share_screen/widgets/shading_background.dart';
import 'package:explorer/screens/share_screen/widgets/shared_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? this will appear when the device isn't connected to any groups, to show my share space
class NotSharingView extends StatelessWidget {
  const NotSharingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var serverProvider = Provider.of<ServerProvider>(context);

    var shareProvider = Provider.of<ShareProvider>(context);
    return Expanded(
      child: Stack(
        children: [
          if (shareProvider.sharedItems.isNotEmpty)
            SharedItems()
          else
            EmptyShareItems(),
          if (serverProvider.httpServer == null) ShadingBackground(),
        ],
      ),
    );
  }
}
