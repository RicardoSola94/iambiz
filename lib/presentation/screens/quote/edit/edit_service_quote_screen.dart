import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/domain/entities/producto_cotizado.dart/producto_cotizado_model.dart';
import 'package:iambiz/domain/entities/services/service_model.dart';
import 'package:iambiz/presentation/providers/inventory/inventory_providers.dart';
import 'package:iambiz/presentation/providers/quotations/quotation_draft_providers.dart';
import 'package:iambiz/presentation/screens/quote/shimmer_loading/quote_client_loading_shimmer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../config/colors.dart';
import '../../../providers/services_providers/service_providers.dart';

class QuoteEditSelectServiceScreen extends ConsumerStatefulWidget {
  const QuoteEditSelectServiceScreen({super.key});

  @override
  ConsumerState<QuoteEditSelectServiceScreen> createState() =>
      _QuoteEditSelectItemsScreenState();
}

class _QuoteEditSelectItemsScreenState
    extends ConsumerState<QuoteEditSelectServiceScreen> {
  String search = '';

  final Set<String> selectedServiceIds = {};

  @override
  Widget build(BuildContext context) {
    final serviciosAsync = ref.watch(servicesProvider);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),

          SafeArea(
            child: serviciosAsync.when(
              loading: () => ClienteSelectShimmer(),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (services) => _buildMainContent(context, services),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton.extended(
          label: Text('Nuevo servicio', style: TextStyle(color: Colors.white)),
          icon: const Icon(CupertinoIcons.add, color: Colors.white),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            context.go('/quote-servicio-add');
          },
        ),
      ),
    );
  }

  Widget _buildItemList<T>({
    required List<T> items,
    required Set<String> selectedIds,
    required Function(T) onTap,
  }) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        final id = (item as dynamic).id as String;
        final name = (item as dynamic).name as String;

        final isSelected = selectedIds.contains(id);

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
            title: Text(
              name,
              style: TextStyle(
                fontFamily: 'SF-UI-DISPLAY',
                fontWeight: FontWeight.bold,
              ),
            ),
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

  Widget _buildMainContent(BuildContext context, List<ServiceModel> service) {
    final filtered =
        service
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
                      onTap: () => context.pop(),
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
          Text('Seleccionar Servicios', style: IAmBizTheme.h2TextStyle),
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
              selectedIds: selectedServiceIds,
              onTap: (item) {
                setState(() {
                  selectedServiceIds.contains(item.id)
                      ? selectedServiceIds.remove(item.id)
                      : selectedServiceIds.add(item.id);
                });
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final servicios =
                  ref
                      .read(servicesProvider)
                      .value
                      ?.where((s) => selectedServiceIds.contains(s.id))
                      .toList() ??
                  [];

              ref.read(quotationDraftProvider.notifier).addServices(servicios);

              context.pop();
            },
            label: const Text("Guardar", style: TextStyle(color: Colors.white)),
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
