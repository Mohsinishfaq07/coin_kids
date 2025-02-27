import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<File> resizeImage(File originalFile, {int targetSize = 200}) async {
    try {
      // Read original file
      final originalImage = img.decodeImage(await originalFile.readAsBytes());
      if (originalImage == null) throw Exception('Failed to decode image');

      // Calculate new dimensions maintaining aspect ratio
      int newWidth, newHeight;
      if (originalImage.width > originalImage.height) {
        newWidth = targetSize;
        newHeight = (targetSize * originalImage.height / originalImage.width).round();
      } else {
        newHeight = targetSize;
        newWidth = (targetSize * originalImage.width / originalImage.height).round();
      }

      // Resize image
      final resizedImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final targetPath = '$tempPath/resized_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Save resized image
      final File resizedFile = File(targetPath);
      await resizedFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 85));

      return resizedFile;
    } catch (e) {
      print('Error resizing image: $e');
      return originalFile; // Return original file if resize fails
    }
  }
} 