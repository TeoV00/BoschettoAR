import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

enum SourceType {
  url,
  assetPath,
}

class RoundImage extends StatelessWidget {
  final String? urlOrAsset;
  final SourceType srcType;
  final Widget defaultWidget;
  final double size;

  const RoundImage(
      {super.key,
      required this.urlOrAsset,
      required this.srcType,
      required this.defaultWidget,
      required this.size});

  @override
  Widget build(BuildContext context) {
    Widget childImage;

    if (urlOrAsset != null) {
      if (srcType == SourceType.url) {
        childImage = CachedNetworkImage(
          imageUrl: urlOrAsset!,
          placeholder: (context, url) => const CircularProgressIndicator(
            color: mainColor,
          ),
          errorWidget: (context, url, error) {
            return defaultWidget;
          },
        );
      } else if (srcType == SourceType.assetPath) {
        childImage = Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(urlOrAsset!),
        );
      } else {
        childImage = defaultWidget;
      }
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
