import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/presentation/screens/inventory/inventory_loading_shimmer.dart';
import 'package:iambiz/presentation/screens/widgets/custom_shimmer_tile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../config/colors.dart';
import '../../providers/inventory/inventory_providers.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);

    return SafeArea(
      child: Scaffold(
        body: inventoryAsync.when(
          data: (items) {
            final filteredItems =
                items
                    .where(
                      (item) => item.name.toLowerCase().contains(searchQuery),
                    )
                    .toList();

            return Column(
              children: [
                //const SizedBox(height: 10),
                Text('Mi Inventario', style: IAmBizTheme.h1TextStyle),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar producto...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child:
                      filteredItems.isEmpty
                          ? const Center(
                            child: Text('No se encontraron productos.'),
                          )
                          : ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return InventoryItemWidget(
                                name: item.name,
                                quantity: item.quantity,
                                unit: item.unit,
                                minQuantity: item.minQuantity,
                                category: item.category,
                                purchasePrice: item.purchasePrice,
                              );
                            },
                          ),
                ),
              ],
            );
          },
          loading:
              () => const InventoryLoadingShimmer(), // 👈 Aquí reemplazas TODO
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: FloatingActionButton.extended(
            heroTag: 'fab_nuevo_inventory',
            label: const Text(
              'Nuevo Inventario',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(CupertinoIcons.add, color: Colors.white),
            onPressed: () => context.go('/add-inventory'),
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}

class InventoryItemWidget extends StatelessWidget {
  final String name;
  final int quantity;
  final String unit;
  final int minQuantity;
  final String category;
  final double purchasePrice;

  const InventoryItemWidget({
    super.key,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.minQuantity,
    required this.category,
    required this.purchasePrice,
  });

  // Retorna el color según nivel de stock
  Color getStockColor() {
    if (quantity == 0) return Colors.red.shade400; // Vacío
    if (quantity <= minQuantity) return Colors.orange.shade400; // Bajo stock
    return Colors.green.shade400; // Stock suficiente
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white70,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightprimaryColor,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Borde lateral derecho indicador
          Container(
            width: 6,
            height: 70,
            decoration: BoxDecoration(
              color: getStockColor(),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(width: 12),

          // Información principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primera línea: nombre - cantidad + unidad - alerta
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$quantity $unit',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),

                SizedBox(height: 6),

                // Segunda línea: categoría
                Text(
                  category,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                SizedBox(height: 6),

                // Tercera línea: precio de compra
                Text(
                  'Precio compra: \$${purchasePrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
