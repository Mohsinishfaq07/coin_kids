import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cached_network_image_widget.dart';

enum ImageType { network, file, asset, none }

class CircleAvatarWidget extends StatelessWidget {
  final String? imagePath;
  final ImageType imageType;
  final double size;
  final Color? backgroundColor;
  final Widget? child;
  final VoidCallback? onTap;
  final bool showLoading;
  final BoxBorder? border;
  final String? placeholderAsset;
  final String? errorAsset;

  const CircleAvatarWidget({
    Key? key,
    this.imagePath = '',
    this.imageType = ImageType.none,
    this.size = 40,
    this.backgroundColor,
    this.child,
    this.onTap,
    this.showLoading = true,
    this.border,
    this.placeholderAsset,
    this.errorAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.grey[200],
          border: border,
        ),
        child: ClipOval(
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath == null) {
      return _buildDefaultChild();
    }

    switch (imageType) {
      case ImageType.network:
        return imagePath!.isNotEmpty
            ? CachedNetworkImageWidget(
                imageUrl: imagePath!,
                width: size.w,
                height: size.w,
                placeholderAsset: placeholderAsset,
                errorAsset: errorAsset,
                showLoading: showLoading,
              )
            : _buildDefaultChild();

      case ImageType.file:
        return imagePath!.isNotEmpty
            ? Image.file(
                File(imagePath!),
                width: size.w,
                height: size.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
              )
            : _buildDefaultChild();

      case ImageType.asset:
        return imagePath!.isNotEmpty
            ? Image.asset(
                imagePath!,
                width: size.w,
                height: size.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
              )
            : _buildDefaultChild();

      case ImageType.none:
        return _buildDefaultChild();
    }
  }

  Widget _buildDefaultChild() {
    return child ??
        Icon(
          Icons.person,
          size: (size * 0.6).w,
          color: Colors.white,
        );
  }

  Widget _buildErrorWidget() {
    if (errorAsset != null) {
      return Image.asset(
        errorAsset!,
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
      );
    }
    return Icon(
      Icons.error_outline,
      size: (size * 0.6).w,
      color: Colors.grey,
    );
  }
}
