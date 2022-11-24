import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return OperationButton(
      iconName: 'send',
      onTap: () => Provider.of<FilesOperationsProvider>(context, listen: false)
          .shareFiles(Provider.of<ExplorerProvider>(context, listen: false)),
    );
  }
}
