import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuoteDetailsShimmer extends StatelessWidget {
  const QuoteDetailsShimmer({super.key});

  Widget _buildShimmerBlock({double height = 20, double width = 100}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // AppBar simulado
            SizedBox(
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildShimmerBlock(height: 28, width: 140),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fecha y estado
            _buildShimmerBlock(height: 16, width: 120),

            const SizedBox(height: 24),

            // Lista de productos/servicios
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => _buildShimmerTile(),
              ),
            ),

            const SizedBox(height: 20),

            // Total
            Align(
              alignment: Alignment.centerRight,
              child: _buildShimmerBlock(height: 22, width: 100),
            ),

            const SizedBox(height: 20),

            // Botón inferior
            _buildShimmerBlock(height: 50, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
