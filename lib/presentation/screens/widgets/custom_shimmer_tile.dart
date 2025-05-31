import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerTile extends StatelessWidget {
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry margin;

  const CustomShimmerTile({
    super.key,
    this.height = 100,
    this.borderRadius = 12,
    this.margin = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
