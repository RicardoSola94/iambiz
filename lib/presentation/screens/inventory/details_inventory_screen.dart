import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/presentation/providers/inventory/inventory_providers.dart';
import '../widgets/custom_button.dart';

class InventoryDetailsScreen extends ConsumerWidget {
  final String id;

  const InventoryDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref
        .watch(inventoryProvider)
        .maybeWhen(
          data: (inventory) {
            try {
              return inventory.firstWhere((c) => c.id == id);
            } catch (_) {
              return null;
            }
          },
          orElse: () => null,
        );

    return Scaffold(
      body:
          inventory == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Fondo decorativo
                            Positioned(
                              top: -330,
                              right: -330,
                              child: Container(
                                height: 600,
                                width: 600,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightprimaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -125,
                              right: -125,
                              child: Container(
                                height: 450,
                                width: 450,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.lightprimaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 15,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 60),
                                  // Encabezado
                                  SizedBox(
                                    height: 50,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Detalles",
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: () => context.pop(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.15),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: const Icon(
                                                Icons
                                                    .arrow_back_ios_new_rounded,
                                                size: 26,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // Datos del cliente
                                  _InfoItem(
                                    title: "Nombre",
                                    value: inventory.name,
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoItem(
                                    title: "Categoria",
                                    value: inventory.category,
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoItem(
                                    title: "Unidad",
                                    value: inventory.unit,
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoItem(
                                    title: "Cantidad",
                                    value: inventory.quantity.toString(),
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoItem(
                                    title: "Cantidad Mínima",
                                    value: inventory.minQuantity.toString(),
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoItem(
                                    title: "Precio de Compra",
                                    value: inventory.purchasePrice.toString(),
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoItem(
                                    title: "Precio de Venta",
                                    value: inventory.salePrice.toString(),
                                  ),

                                  const SizedBox(height: 40),

                                  // Botón de Editar
                                  CustomButton(
                                    text: 'Editar',
                                    icon: FontAwesomeIcons.penToSquare,
                                    isLarge: true,
                                    onPressed: () {
                                      context.push(
                                        '/edit-inventory',
                                        extra: inventory,
                                      );
                                      ref.invalidate(inventoryProvider);
                                    },
                                  ),

                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
