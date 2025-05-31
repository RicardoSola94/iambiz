import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/domain/entities/inventory/inventory_model.dart';
import 'package:iambiz/domain/entities/producto_cotizado.dart/producto_cotizado_model.dart';
import 'package:iambiz/presentation/providers/inventory/inventory_providers.dart';
import 'package:iambiz/presentation/providers/quotations/quotation_draft_providers.dart';
import '../../../../config/colors.dart';
import '../shimmer_loading/quote_client_loading_shimmer.dart';

class QuoteSelectProductsScreen extends ConsumerStatefulWidget {
  const QuoteSelectProductsScreen({super.key});

  @override
  ConsumerState<QuoteSelectProductsScreen> createState() =>
      _QuoteSelectProductsScreenState();
}

class _QuoteSelectProductsScreenState
    extends ConsumerState<QuoteSelectProductsScreen> {
  bool showProducts = true;
  String search = '';

  final Map<String, int> selectedProducts = {};

  @override
  Widget build(BuildContext context) {
    final productosAsync = ref.watch(inventoryProvider);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),

          SafeArea(
            child: productosAsync.when(
              loading: () => ClienteSelectShimmer(),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (productos) => _buildMainContent(context, productos),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton.extended(
          label: Text('Nuevo producto', style: TextStyle(color: Colors.white)),
          icon: const Icon(CupertinoIcons.add, color: Colors.white),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            context.go('/quote-producto-add');
          },
        ),
      ),
    );
  }

  Widget _buildItemList<T>({
    required List<T> items,
    required Map<String, int> selectedIds,
    required Function(T) onTap,
  }) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        final id = (item as dynamic).id as String;
        final name = (item as dynamic).name as String;
        final precio = (item as dynamic).purchasePrice as double;

        final isSelected = selectedIds.containsKey(id);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.lightprimaryColor.withOpacity(0.2)
                    : Colors.white70,
            boxShadow: [
              BoxShadow(
                color: AppColors.lightprimaryColor.withOpacity(0.5),
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'SF-UI-DISPLAY',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  precio.toString(),
                  style: TextStyle(fontFamily: 'SF-UI-DISPLAY'),
                ),
              ],
            ),
            subtitle:
                isSelected
                    ? Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              final currentQty = selectedProducts[id]!;
                              if (currentQty > 1) {
                                selectedProducts[id] = currentQty - 1;
                              }
                            });
                          },
                        ),
                        Text('${selectedProducts[id]}'),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              selectedProducts[id] = selectedProducts[id]! + 1;
                            });
                          },
                        ),
                      ],
                    )
                    : null,

            trailing:
                isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
            onTap: () => onTap(item),
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -330,
          right: -330,
          child: Container(
            height: 600,
            width: 600,
            decoration: BoxDecoration(
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
              border: Border.all(color: AppColors.lightprimaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    List<InventoryModel> clientes,
  ) {
    final filtered =
        clientes
            .where((c) => c.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              // vertical: 12.0,
            ),
            child: SizedBox(
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Texto centrado en pantalla
                  Center(
                    child: Text("Cotización", style: IAmBizTheme.h1TextStyle),
                  ),

                  // Flecha atrás en la esquina izquierda
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.15,
                              ), // Sombra suave
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 26,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Seleccionar Productos', style: IAmBizTheme.h2TextStyle),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildItemList(
              items: filtered,
              selectedIds: selectedProducts,
              onTap: (item) {
                setState(() {
                  if (selectedProducts.containsKey(item.id)) {
                    selectedProducts.remove(item.id);
                  } else {
                    selectedProducts[item.id] =
                        1; // cantidad inicial por defecto
                  }
                });
              },
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {
              final productosInventario =
                  ref
                      .read(inventoryProvider)
                      .value
                      ?.where((p) => selectedProducts.containsKey(p.id))
                      .toList() ??
                  [];

              final productosCotizados =
                  productosInventario
                      .map(
                        (producto) => ProductoCotizado.fromProducto(
                          producto,
                          selectedProducts[producto.id] ??
                              1, // cantidad específica
                        ),
                      )
                      .toList();

              ref
                  .read(quotationDraftProvider.notifier)
                  .addItems(productosCotizados);

              context.push('/quote-service');
            },

            label: const Text(
              "Siguiente",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              disabledBackgroundColor: AppColors.lightprimaryColor,
              backgroundColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
