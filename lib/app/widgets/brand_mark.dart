import 'package:flutter/material.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.height = 72, this.compact = false});

  final double height;
  final bool compact;

  static const assetPath = 'assets/brand/prana_logo.png';
  static const fallbackPath = 'assets/brand/prana_logo.jpeg';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      height: height,
      width: compact ? height : null,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'PRANA',
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          fallbackPath,
          height: height,
          width: compact ? height : null,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          semanticLabel: 'PRANA',
        );
      },
    );
  }
}
