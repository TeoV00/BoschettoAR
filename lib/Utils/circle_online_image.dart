import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundOnlineImage extends StatelessWidget {
  final String? url;
  final Widget defaultWidget;
  final double size;

  const RoundOnlineImage(
      {super.key, this.url, required this.defaultWidget, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url ?? '',
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            log('message');
            return defaultWidget;
          },
        ),
      ),
    );
  }
}
