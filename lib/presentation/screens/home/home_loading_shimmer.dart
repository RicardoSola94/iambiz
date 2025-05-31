import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  Widget _buildShimmerBox({
    double height = 16,
    double width = double.infinity,
    BorderRadius? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildResumenBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: _buildShimmerBox(
        height: 200,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildCotizacionesItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildShimmerBox(
        height: 60,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildTimelineItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          _buildShimmerBox(
            height: 20,
            width: 20,
            borderRadius: BorderRadius.circular(50),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildShimmerBox(height: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          _buildShimmerBox(height: 28, width: 180), // Título
          const SizedBox(height: 8),
          _buildShimmerBox(height: 16, width: 240), // Subtítulo
          const SizedBox(height: 24),
          _buildResumenBox(),
          const SizedBox(height: 32),
          _buildShimmerBox(height: 20, width: 160), // Título Cotizaciones
          const SizedBox(height: 12),
          ...List.generate(3, (_) => _buildCotizacionesItem()),
          const SizedBox(height: 24),
          _buildShimmerBox(height: 20, width: 120), // Título Para hoy
          const SizedBox(height: 12),
          ...List.generate(4, (_) => _buildTimelineItem()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
