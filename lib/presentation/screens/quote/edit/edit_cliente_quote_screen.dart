import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/presentation/providers/cliente_providers/clientes_providers.dart';
import 'package:iambiz/presentation/providers/quotations/quotation_draft_providers.dart';
import 'package:iambiz/presentation/screens/quote/shimmer_loading/quote_client_loading_shimmer.dart';

import '../../../../domain/entities/clientes/clientes_model.dart';

class QuoteEditSelectClientScreen extends ConsumerStatefulWidget {
  const QuoteEditSelectClientScreen({super.key});

  @override
  ConsumerState<QuoteEditSelectClientScreen> createState() =>
      _QuoteSelectClientScreenState();
}

class _QuoteSelectClientScreenState
    extends ConsumerState<QuoteEditSelectClientScreen> {
  String search = '';
  ClienteModel? selectedClient;

  @override
  Widget build(BuildContext context) {
    final clientesAsync = ref.watch(clientesProvider);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: clientesAsync.when(
              loading: () => ClienteSelectShimmer(),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (clientes) => _buildMainContent(context, clientes),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton.extended(
          label: const Text(
            'Nuevo cliente',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(CupertinoIcons.add, color: Colors.white),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            context.push('/quote-cliente-add');
          },
        ),
      ),
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

  Widget _buildMainContent(BuildContext context, List<ClienteModel> clientes) {
    final filtered =
        clientes
            .where((c) => c.nombre.toLowerCase().contains(search.toLowerCase()))
            .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // App bar custom
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
          Text('Seleccionar Cliente', style: IAmBizTheme.h2TextStyle),
          const SizedBox(height: 16),
          // Campo de búsqueda
          TextField(
            decoration: InputDecoration(
              labelText: "Buscar cliente",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (val) => setState(() => search = val),
          ),

          const SizedBox(height: 16),

          // Lista de clientes
          Expanded(
            child:
                filtered.isEmpty
                    ? const Center(child: Text("No existen clientes"))
                    : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final cliente = filtered[index];
                        final isSelected = selectedClient?.id == cliente.id;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.lightprimaryColor.withOpacity(
                                      0.2,
                                    )
                                    : Colors.white70,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightprimaryColor.withOpacity(
                                  0.5,
                                ),
                                blurRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              cliente.nombre,
                              style: TextStyle(
                                fontFamily: 'SF-UI-DISPLAY',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(cliente.telefono),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 28,
                                    )
                                    : null,
                            selected: isSelected,
                            onTap:
                                () => setState(() => selectedClient = cliente),
                          ),
                        );
                      },
                    ),
          ),
          // Botón siguiente
          ElevatedButton(
            onPressed:
                selectedClient == null
                    ? null
                    : () {
                      ref
                          .read(quotationDraftProvider.notifier)
                          .setClient(selectedClient!);
                      context.pop();
                    },

            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              textStyle: TextStyle(fontSize: 16.0),
              disabledBackgroundColor: AppColors.lightprimaryColor,
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text("Guardar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
