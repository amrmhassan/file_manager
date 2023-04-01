// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/locale_rotation_wrapper.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/path_entity_text.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PathRow extends StatelessWidget {
  final bool sizesExplorer;
  final String? customPath;
  final VoidCallback? onCopy;
  final Function(String subPath)? onClickingSubPath;
  const PathRow({
    super.key,
    required this.sizesExplorer,
    required this.customPath,
    required this.onCopy,
    required this.onClickingSubPath,
  });

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    String path = customPath ?? expProvider.currentActiveDir.path;
    initialDirs
        .where(
      (element) => element.path != initialDirs.first.path,
    )
        .forEach((mainDisk) {
      path = path.replaceFirst(
        mainDisk.path,
        mainDisksMapper[mainDisk.path] ?? mainDisk.path,
      );
    });
    path = path.replaceAll('//', '/');
    path = path.replaceAll('\\', '/');
    List<String> folders = path.split('/');

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
                    onTap: () => onRowClickedHandler(
                      context,
                      entry,
                      folders,
                      expProviderFalse,
                    ),
                  ),
                  if (entry.key != folders.length - 1)
                    LocaleRotationWrapper(
                      child: Image.asset(
                        'assets/icons/right-arrow.png',
                        width: smallIconSize,
                        color: kInactiveColor,
                      ),
                    )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  void onRowClickedHandler(
    BuildContext context,
    MapEntry<int, String> entry,
    List<String> folders,
    ExplorerProvider expProviderFalse,
  ) {
    var analyzerProvider =
        Provider.of<AnalyzerProvider>(context, listen: false);
    if (entry.key != folders.length - 1) {
      String newPath = folders.sublist(0, entry.key + 1).join('/');
      mainDisksMapper.forEach((key, value) {
        newPath = newPath.replaceFirst(value, key);
      });

      if (onClickingSubPath != null) {
        onClickingSubPath!(newPath);
      } else {
        var foProviderFalse = Provider.of<FilesOperationsProvider>(
          context,
          listen: false,
        );
        expProviderFalse.setActiveDir(
          sizesExplorer: sizesExplorer,
          path: newPath,
          analyzerProvider: analyzerProvider,
          filesOperationsProvider: foProviderFalse,
        );
      }
    } else {
      if (onCopy != null) {
        onCopy!();
      } else {
        copyToClipboard(context, expProviderFalse.currentActiveDir.path);
      }
    }
  }
}
