import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

enum AppImageType { asset, network, cached }

class AppImage extends StatelessWidget {
  final String path;
  final AppImageType type;

  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.path,
    required this.type,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;

    switch (type) {
      case AppImageType.asset:
        image = Image.asset(
          path,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _defaultErrorWidget();
          },
        );
        break;

      case AppImageType.network:
        image = Image.network(
          path,
          height: height,
          width: width,
          fit: fit,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return placeholder ?? _defaultShimmer();
          },
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _defaultErrorWidget();
          },
        );
        break;

      case AppImageType.cached:
        image = CachedNetworkImage(
          imageUrl: path,
          height: height,
          width: width,
          fit: fit,
          placeholder: (context, url) => placeholder ?? _defaultShimmer(),
          errorWidget: (context, url, error) =>
              errorWidget ?? _defaultErrorWidget(),
        );
        break;
    }

    // Wrap with ClipRRect for rounded corners if needed
    return borderRadius != null
        ? ClipRRect(borderRadius: borderRadius!, child: image)
        : image;
  }

  Widget _defaultShimmer() => Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(height: height, width: width, color: Colors.grey.shade300),
  );

  Widget _defaultErrorWidget() => const Icon(Icons.broken_image, size: 32);
}
