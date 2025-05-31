import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/config.dart';
import '../../providers/quotations/quotations_providers.dart';
import '../clientes/clientes_loading_shimmer.dart';

class QuotationScreen extends ConsumerStatefulWidget {
  const QuotationScreen({super.key});

  @override
  ConsumerState<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends ConsumerState<QuotationScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final quotationsAsync = ref.watch(quotationProvider);

    Color _getStatusColor(String status) {
      switch (status) {
        case 'borrador':
          return Colors.orange;
        case 'enviada':
          return Colors.blue;
        case 'aceptada':
          return Colors.green;
        case 'cancelada':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    String _getStatusLabel(String status) {
      switch (status) {
        case 'borrador':
          return 'No Enviado';
        case 'enviada':
          return 'Enviada';
        case 'aceptada':
          return 'Aceptada';
        case 'cancelada':
          return 'Cancelada';
        default:
          return 'Desconocido';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: quotationsAsync.when(
          loading: () => ClientesLoadingShimmer(),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (quota) {
            final filteredQuotations =
                quota
                    .where(
                      (item) => item.name.toLowerCase().contains(searchQuery),
                    )
                    .toList();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Texto centrado en pantalla
                        Center(
                          child: Text(
                            "Cotizaciones",
                            style: IAmBizTheme.h1TextStyle,
                          ),
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
                        hintText: 'Buscar cotización...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  filteredQuotations.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.doc_text,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No hay cotizaciones recientes',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Expanded(
                        child: ListView.builder(
                          itemCount: filteredQuotations.length,
                          itemBuilder: (context, index) {
                            final cotizacion = filteredQuotations[index];
                            return GestureDetector(
                              onTap: () {
                                context.go('/quote-details/${cotizacion.id}');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
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
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cotizacion.name,
                                            style: IAmBizTheme.bodyTextTheme,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Cliente: ${cotizacion.client.nombre} | Total: \$${cotizacion.total.toStringAsFixed(2)}',
                                            style:
                                                IAmBizTheme.subtitlesTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${cotizacion.createdAt.day}/${cotizacion.createdAt.month}/${cotizacion.createdAt.year}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(
                                              cotizacion.status,
                                            ).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            _getStatusLabel(cotizacion.status),
                                            style: TextStyle(
                                              color: _getStatusColor(
                                                cotizacion.status,
                                              ),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
