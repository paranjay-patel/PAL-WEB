import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';

class CacheNetworkImage extends StatelessWidget {
  final double height;
  final String imageUrl;
  final Color? overlayColor;

  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  const CacheNetworkImage({Key? key, required this.height, required this.imageUrl, this.overlayColor, this.errorWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overlayColor = this.overlayColor;
    return CachedNetworkImage(
      height: height,
      imageUrl: imageUrl,
      fadeInDuration: const Duration(milliseconds: 200),
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.zero),
            image: DecorationImage(
              image: imageProvider,
              colorFilter: (overlayColor != null) ? ColorFilter.mode(overlayColor, BlendMode.srcATop) : null,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        decoration: const BoxDecoration(
          color: ThemeColors.dark60,
          borderRadius: BorderRadius.all(Radius.zero),
        ),
      ),
      errorWidget: errorWidget,
    );
  }
}
