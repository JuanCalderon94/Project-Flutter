import 'package:flutter/material.dart';

Widget buildProductImage(
  String? imagenUrl, {
  String fallbackAsset = 'assets/img/image.png',
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  if (imagenUrl != null && imagenUrl.isNotEmpty) {
    if (imagenUrl.startsWith('http')) {
      return Image.network(
        imagenUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            Image.asset(fallbackAsset, width: width, height: height, fit: fit),
      );
    }
    if (imagenUrl.startsWith('asset:')) {
      final path = imagenUrl.replaceFirst('asset:', '');
      return Image.asset(path, width: width, height: height, fit: fit);
    }
  }
  return Image.asset(fallbackAsset, width: width, height: height, fit: fit);
}
