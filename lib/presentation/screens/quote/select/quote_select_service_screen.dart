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

class QuoteSelectServiceScreen extends ConsumerStatefulWidget {
  const QuoteSelectServiceScreen({super.key});

  @override
  ConsumerState<QuoteSelectServiceScreen> createState() =>
      _QuoteSelectItemsScreenState();
}

class _QuoteSelectItemsScreenState
    extends ConsumerState<QuoteSelectServiceScreen> {
  String search = '';

  final Set<String> selectedServiceIds = {};

  @override
  Widget build(BuildContext context) {
    final serviciosAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cotización',
          style: IAmBizTheme.h1TextStyle.copyWith(), // o el color que necesites
        ),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 26),
        ),
      ),
      body: Stack(
        children: [
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

  Widget _buildMainContent(BuildContext context, List<ServiceModel> service) {
    final filtered =
        service
            .where((c) => c.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),
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
            onPressed:
                selectedServiceIds.isEmpty
                    ? null
                    : () {
                      final servicios =
                          ref
                              .read(servicesProvider)
                              .value
                              ?.where((s) => selectedServiceIds.contains(s.id))
                              .toList() ??
                          [];

                      ref
                          .read(quotationDraftProvider.notifier)
                          .addServices(servicios);
                      context.push('/quote-summary');
                    },

            label: const Text(
              "Continuar",
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
