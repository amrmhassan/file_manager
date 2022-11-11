// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/home_screen/widgets/path_entity_text.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PathRow extends StatelessWidget {
  final bool sizesExplorer;
  const PathRow({
    super.key,
    required this.sizesExplorer,
  });

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    List<String> folders = expProvider.currentActiveDir.path.split('/');
    var analyzerProvieer =
        Provider.of<AnalyzerProvider>(context, listen: false);

    return GestureDetector(
      onLongPress: () =>
          copyPathToClipboard(context, expProviderFalse.currentActiveDir.path),
      child: Row(
        children: [
          ...folders.asMap().entries.map(
            (entry) {
              return Row(
                children: [
                  PathEntityText(
                    pathEntity: entry.value,
                    onTap: () {
                      if (entry.key != folders.length - 1) {
                        String newPath =
                            folders.sublist(0, entry.key + 1).join('/');
                        expProviderFalse.setActiveDir(
                          sizesExplorer: sizesExplorer,
                          path: newPath,
                          analyzerProvider: analyzerProvieer,
                        );
                      } else {
                        copyPathToClipboard(
                            context, expProviderFalse.currentActiveDir.path);
                      }
                    },
                  ),
                  if (entry.key != folders.length - 1)
                    Image.asset(
                      'assets/icons/right-arrow.png',
                      width: smallIconSize,
                      color: kInactiveColor,
                    )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
