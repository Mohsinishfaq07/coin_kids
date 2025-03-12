import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final String? placeholderAsset;
  final String? errorAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Widget? loadingWidget;
  final bool showLoading;
  final Color? iconColor;

  const CachedNetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.placeholderAsset,
    this.errorAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.loadingWidget,
    this.showLoading = true,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    if (!showLoading) {
      return _buildAssetImage(placeholderAsset);
    }

    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey[200],
      child: Center(
        child: loadingWidget ??
            CircularProgressIndicator(
              strokeWidth: 2.w,
            ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      child: _buildAssetImage(errorAsset),
    );
  }

  Widget _buildAssetImage(String? asset) {
    if (asset == null) {
      return Icon(
        Icons.error_outline,
        size: 24.sp,
        color: Colors.grey,
      );
    }

    return asset.endsWith("svg")
        ? SvgPicture.asset(
            asset,
            width: width,
            height: height,
            fit: fit,
            color: iconColor != null ? iconColor : null,
          )
        : Image.asset(
            asset,
            width: width,
            height: height,
            fit: fit,
            color: iconColor != null ? iconColor : null,
          );
  }
}

// // Basic usage
// CachedNetworkImageWidget(
//   imageUrl: 'https://example.com/image.jpg',
//   width: 100.w,
//   height: 100.h,
// );

// // With placeholder and error assets
// CachedNetworkImageWidget(
//   imageUrl: 'https://example.com/image.jpg',
//   placeholderAsset: 'assets/images/placeholder.png',
//   errorAsset: 'assets/images/error.png',
//   width: 100.w,
//   height: 100.h,
// );

// // With custom styling
// CachedNetworkImageWidget(
//   imageUrl: 'https://example.com/image.jpg',
//   width: 100.w,
//   height: 100.h,
//   fit: BoxFit.contain,
//   borderRadius: BorderRadius.circular(12.r),
//   backgroundColor: Colors.grey[100],
// );

// // With custom loading widget
// CachedNetworkImageWidget(
//   imageUrl: 'https://example.com/image.jpg',
//   width: 100.w,
//   height: 100.h,
//   loadingWidget: const SpinKitCircle(
//     color: Colors.blue,
//     size: 24,
//   ),
// );

// // Without loading indicator
// CachedNetworkImageWidget(
//   imageUrl: 'https://example.com/image.jpg',
//   width: 100.w,
//   height: 100.h,
//   showLoading: false,
// );
