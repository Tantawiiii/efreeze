import 'dart:io';

import 'package:efreeze/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum AvatarPickStatus { success, cancelled, tooLarge }

class AvatarPickResult {
  const AvatarPickResult._({required this.status, this.file});

  final AvatarPickStatus status;
  final File? file;

  factory AvatarPickResult.cancelled() =>
      const AvatarPickResult._(status: AvatarPickStatus.cancelled);

  factory AvatarPickResult.tooLarge() =>
      const AvatarPickResult._(status: AvatarPickStatus.tooLarge);

  factory AvatarPickResult.success(File file) =>
      AvatarPickResult._(status: AvatarPickStatus.success, file: file);
}

class PickAvatarService {
  PickAvatarService._();

  static final ImagePicker _picker = ImagePicker();

  /// API max avatar size: 2048 KB.
  static const int maxAvatarBytes = 2048 * 1024;

  static Future<AvatarPickResult> pickAvatar(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) return AvatarPickResult.cancelled();
    } else {
      await Permission.photos.request();
      await Permission.storage.request();
    }

    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (file == null) return AvatarPickResult.cancelled();

    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 75,
      maxWidth: 512,
      maxHeight: 512,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.primaryColor,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (cropped == null) return AvatarPickResult.cancelled();

    final compressed = await compressAvatar(File(cropped.path));
    if (compressed == null) return AvatarPickResult.tooLarge();

    return AvatarPickResult.success(compressed);
  }

  /// Ensures avatar is under the API size limit (2048 KB).
  static Future<File?> compressAvatar(File file) async {
    var current = file;
    var quality = 85;

    while (quality >= 30) {
      final size = await current.length();
      if (size <= maxAvatarBytes) return current;

      final compressed = await _compressFile(current, quality: quality);
      if (compressed == null) break;

      current = compressed;
      if (await current.length() <= maxAvatarBytes) return current;
      quality -= 15;
    }

    final finalSize = await current.length();
    return finalSize <= maxAvatarBytes ? current : null;
  }

  static Future<File?> _compressFile(File file, {required int quality}) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: 512,
      minHeight: 512,
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }
}
