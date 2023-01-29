// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/util/analyzer_provider.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/path_entity_text.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PathRow extends StatelessWidget {
  final bool sizesExplorer;
  final String? customPath;
  final VoidCallback? onCopy;

  const PathRow({
    super.key,
    required this.sizesExplorer,
    required this.customPath,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    List<String> folders =
        (customPath ?? expProvider.currentActiveDir.path).split('/');
    var analyzerProvider =
        Provider.of<AnalyzerProvider>(context, listen: false);

    return GestureDetector(
      onLongPress: onCopy ??
          () =>
              copyToClipboard(context, expProviderFalse.currentActiveDir.path),
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
                        var foProviderFalse =
                            Provider.of<FilesOperationsProvider>(
                          context,
                          listen: false,
                        );
                        expProviderFalse.setActiveDir(
                          sizesExplorer: sizesExplorer,
                          path: newPath,
                          analyzerProvider: analyzerProvider,
                          filesOperationsProvider: foProviderFalse,
                        );
                      } else {
                        copyToClipboard(
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
