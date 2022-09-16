import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  final String? url;
  final String? assetPath;
  final Widget defaultWidget;
  final double size;

  const RoundImage(
      {super.key,
      this.url,
      this.assetPath,
      required this.defaultWidget,
      required this.size});

  @override
  Widget build(BuildContext context) {
    Widget childImage;
    if (url != null && assetPath == null) {
      childImage = CachedNetworkImage(
        imageUrl: url ?? '',
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          return defaultWidget;
        },
      );
    } else if (url == null && assetPath != null) {
      childImage = Image.asset(assetPath!);
    } else {
      childImage = defaultWidget;
    }

    return SizedBox(
      height: size,
      width: size,
      child: ClipOval(
        child: childImage,
      ),
    );
  }
}
