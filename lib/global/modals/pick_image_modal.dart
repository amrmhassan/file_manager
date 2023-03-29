// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/share_settings_screen/widgets/image_picking_option_element.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_operations;
import 'package:uuid/uuid.dart';

class PickImageModal extends StatelessWidget {
  const PickImageModal({
    super.key,
  });

  Future<File?> handlePickImage(ImageSource source) async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: source);
    if (pickedFile == null) return null;
    // CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
    //   sourcePath: pickedFile.path,
    //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    // );
    // if (croppedFile == null) return null;
    final newPath = path_operations.join((await getTemporaryDirectory()).path,
        '${Uuid().v4()}${path_operations.extension(pickedFile.path)}');
    File? file = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      newPath,
      quality: 40,
    );
    if (file == null) return null;
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      color: kBackgroundColor,
      showTopLine: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: double.infinity),
          Column(
            children: [
              Text(
                'Choose Image',
                style: h3LiteTextStyle,
              ),
              VSpace()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImagePickingOptionElement(
                iconName: 'camera',
                onTap: () async {
                  try {
                    File? file = await handlePickImage(ImageSource.camera);
                    if (file == null) {
                      showSnackBar(
                        context: context,
                        message: 'Can\'t pick image',
                        snackBarType: SnackBarType.error,
                      );
                      Navigator.pop(context);
                      return;
                    }
                    await sharePF(context).setMyImagePath(file.path);
                    Navigator.pop(context);
                  } catch (e) {
                    logger.e(e);
                    Navigator.pop(context);
                    showSnackBar(
                      context: context,
                      message: 'Can\'t pick an image',
                      snackBarType: SnackBarType.error,
                    );
                  }
                },
              ),
              HSpace(),
              ImagePickingOptionElement(
                iconName: 'gallery',
                onTap: () async {
                  File? file = await handlePickImage(ImageSource.gallery);
                  if (file == null) {
                    showSnackBar(
                      context: context,
                      message: 'Can\'t pick image',
                      snackBarType: SnackBarType.error,
                    );
                    Navigator.pop(context);
                    return;
                  }
                  await sharePF(context).setMyImagePath(file.path);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
