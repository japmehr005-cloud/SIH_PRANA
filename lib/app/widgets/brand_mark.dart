import 'package:flutter/material.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.height = 72,
    this.compact = false,
  });

  final double height;
  final bool compact;

  static const assetPath = 'assets/brand/prana_logo.jpeg';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      height: compact ? height : height,
      width: compact ? height : null,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'PRANA',
    );
  }
}
