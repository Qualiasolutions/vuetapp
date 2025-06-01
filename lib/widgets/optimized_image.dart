import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// Optimized image widget with caching, lazy loading, and error handling
class OptimizedImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableMemoryCache;
  final Duration fadeInDuration;
  final Color? backgroundColor;

  const OptimizedImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.enableMemoryCache = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
  }) : assert(imageUrl != null || assetPath != null, 'Either imageUrl or assetPath must be provided');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (assetPath != null) {
      // Handle asset images
      imageWidget = Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else {
      // Handle network images with caching
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration,
        memCacheWidth: enableMemoryCache ? _getOptimalCacheSize(width) : null,
        memCacheHeight: enableMemoryCache ? _getOptimalCacheSize(height) : null,
        placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
      );
    }

    // Apply border radius if specified
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    // Apply background color if specified
    if (backgroundColor != null) {
      imageWidget = Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Build the default placeholder widget
  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  /// Build the default error widget
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate optimal cache size for memory efficiency
  int? _getOptimalCacheSize(double? size) {
    if (size == null) return null;
    
    // Cap cache size to avoid excessive memory usage
    const maxCacheSize = 800;
    final devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final optimalSize = (size * devicePixelRatio).round();
    
    return optimalSize > maxCacheSize ? maxCacheSize : optimalSize;
  }
}

/// Circular optimized image widget for avatars
class OptimizedCircularImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  const OptimizedCircularImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.radius = 25,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  }) : assert(imageUrl != null || assetPath != null, 'Either imageUrl or assetPath must be provided');

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      child: ClipOval(
        child: OptimizedImage(
          imageUrl: imageUrl,
          assetPath: assetPath,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: placeholder,
          errorWidget: errorWidget ?? _buildDefaultErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Icon(
      Icons.person,
      size: radius,
      color: Colors.grey[600],
    );
  }
}

/// Hero image widget for smooth transitions
class OptimizedHeroImage extends StatelessWidget {
  final String heroTag;
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const OptimizedHeroImage({
    super.key,
    required this.heroTag,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : assert(imageUrl != null || assetPath != null, 'Either imageUrl or assetPath must be provided');

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: OptimizedImage(
        imageUrl: imageUrl,
        assetPath: assetPath,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
      ),
    );
  }
}
