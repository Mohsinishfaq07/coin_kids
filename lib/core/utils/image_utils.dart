import 'dart:ui';

import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource, XFile;

Future<void> pickImage(ImageSource source, VoidCallback onPick(XFile? file), VoidCallback onError(e)) async {
  final ImagePicker _picker = ImagePicker();

  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    onPick(pickedFile);
  } catch (e) {
    onError(e);
    ToastUtil.showToast("Failed to pick image: $e");
  }
}
