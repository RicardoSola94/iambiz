import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/domain/entities/inventory/inventory_model.dart';
import 'package:iambiz/presentation/screens/inventory/inventory_loading_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../config/colors.dart';
import '../../providers/inventory/inventory_providers.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String searchQuery = '';

  final GlobalKey fabInventoryKey = GlobalKey();
  final GlobalKey searchFieldInventoryKey = GlobalKey();
  final GlobalKey firstItemInventoryKey = GlobalKey();

  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final seen = await hasShownTutorial();
      if (!seen) {
        final inventoryItems = ref
            .read(inventoryProvider)
            .maybeWhen(data: (items) => items, orElse: () => []);

        initTargets(hasItems: inventoryItems.isNotEmpty);
        showTutorial();
        await markTutorialAsShown();
      }
    });
  }

  void showTutorial() {
    if (!mounted) return;

    if (targets.any((t) => t.keyTarget?.currentContext == null)) {
      Future.delayed(const Duration(milliseconds: 300), showTutorial);
      return;
    }

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SALTAR",
      paddingFocus: 10,
      onFinish: () {
        print("Tutorial terminado");
      },
      onClickTarget: (target) {
        print('Pulsado ${target.identify}');
      },
    ).show(context: context);
  }

  void initTargets({required bool hasItems}) {
    targets = [
      TargetFocus(
        identify: "Filter",
        keyTarget: searchFieldInventoryKey,
        radius: 10,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              "Usa este campo para buscar productos por nombre.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      if (hasItems)
        TargetFocus(
          identify: "FirstItem",
          keyTarget: firstItemInventoryKey,
          radius: 10,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "Toca aquí para ver los detalles del producto.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        )
      else
        TargetFocus(
          identify: "EmptyState",
          keyTarget: firstItemInventoryKey,
          radius: 10,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "Aquí aparecerán los productos una vez agregues alguno.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      TargetFocus(
        identify: "AddButton",
        keyTarget: fabInventoryKey,
        shape: ShapeLightFocus.Circle,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "Toca aquí para agregar un nuevo producto al inventario.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    ];
  }

  Future<bool> hasShownTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('Inventory_tutorial_shown') ?? false;
  }

  Future<void> markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Inventory_tutorial_shown', true);
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Mi Inventario',
            style:
                IAmBizTheme.h1TextStyle.copyWith(), // o el color que necesites
          ),
        ),
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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    key: searchFieldInventoryKey,
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
                          ? Center(
                            key: firstItemInventoryKey,
                            child: Text('No se encontraron productos.'),
                          )
                          : ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push('/detail-inventory/${item.id}');
                                },
                                child: InventoryItemWidget(
                                  key:
                                      index == 0 ? firstItemInventoryKey : null,
                                  name: item.name,
                                  quantity: item.quantity,
                                  unit: item.unit,
                                  minQuantity: item.minQuantity,
                                  category: item.category,
                                  purchasePrice: item.purchasePrice,
                                ),
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
            key: fabInventoryKey,
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

                Text(
                  category,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                SizedBox(height: 6),

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
