import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

PreferredSizeWidget getAppBar(
  final String title,
  final BuildContext context,
) {
  return AppBar(
    backgroundColor: mainColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        const SizedBox(width: 56),
      ],
    ),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
    ),
  );
}
