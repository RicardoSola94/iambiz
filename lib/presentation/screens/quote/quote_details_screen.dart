import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/presentation/screens/quote/shimmer_loading/quote_details_loading_shimmer.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../domain/entities/quotation/quotation_model.dart';
import '../../providers/quotations/quotation_draft_providers.dart'
    show quotationDraftProvider;
import '../../providers/quotations/quotations_providers.dart';
import '../widgets/generar_quotation_pdf.dart';

class QuoteDetailsScreen extends ConsumerWidget {
  final String quotationId;
  const QuoteDetailsScreen({required this.quotationId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotationAsync = ref
        .read(quotationProvider.notifier)
        .quotationById(quotationId);

    final quotationDraft = ref.watch(quotationDraftProvider);
    final quotationNotifier = ref.read(quotationProvider.notifier);

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
      backgroundColor: Colors.grey.shade50,
      body: FutureBuilder<QuotationModel?>(
        future: quotationAsync, // Asegúrate de tener esta función accesible
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: QuoteDetailsShimmer());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Cotización no encontrada'));
          }

          final quotation = snapshot.data!; // <-- ESTA LÍNEA ES NECESARIA

          final draftNotifier = ref.read(quotationDraftProvider.notifier);
          if (quotationDraft.client == null &&
              quotationDraft.productos.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              draftNotifier.setFromQuotation(quotation);
            });
          }

          //final quotation = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Resumen",
                              style: IAmBizTheme.h1TextStyle,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => context.go('/quotations'),
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

                    // Cliente
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            quotation.status,
                          ).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusLabel(quotation.status),
                          style: TextStyle(
                            color: _getStatusColor(quotation.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cliente',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.push('/quote-cliente-edit');
                                  },
                                  icon: Icon(CupertinoIcons.square_pencil_fill),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            quotationDraft.client != null
                                ? Text(
                                  '${quotationDraft.client!.nombre}\n${quotationDraft.client!.correo ?? ''}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )
                                : Text(
                                  'No se ha seleccionado cliente',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Servicios
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Servicios',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.push('/quote-service-edit');
                                  },
                                  icon: Icon(CupertinoIcons.square_pencil_fill),
                                ),
                              ],
                            ),
                            if (quotation.servicios.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  'No se han añadido servicios',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              )
                            else
                              ...quotationDraft.servicios.map(
                                (s) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(s.name),
                                  trailing: Text(
                                    '\$${s.price.toStringAsFixed(2)}',
                                  ),
                                ),
                              ),
                            const Divider(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Total servicios: \$${quotationDraft.totalServices.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Productos
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Productos',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.push('/quote-producto-edit');
                                  },
                                  icon: Icon(CupertinoIcons.square_pencil_fill),
                                ),
                              ],
                            ),
                            if (quotationDraft.productos.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  'No se han añadido productos',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              )
                            else
                              ...quotationDraft.productos.map(
                                (p) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('${p.name} x${p.quantity}'),
                                  trailing: Text(
                                    '\$${(p.purchasePrice * (p.quantity ?? 1)).toStringAsFixed(2)}',
                                  ),
                                ),
                              ),
                            const Divider(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Total productos: \$${quotationDraft.totalProducts.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Total general
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: AppColors.primaryColor,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total General',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '\$${quotationDraft.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Botón guardar
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save_outlined),
                      label: const Text(
                        'Guardar cotización',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        final pdf = await generateQuotationPdf(quotationDraft);

                        // Mostrar vista previa para imprimir o guardar PDF
                        await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdf.save(),
                        );

                        final quotation = QuotationModel(
                          id: quotationId, // Firebase lo asignará
                          name:
                              'Cotización de ${quotationDraft.client!.nombre}',
                          client: quotationDraft.client!,
                          servicios: quotationDraft.servicios,
                          productos: quotationDraft.productos,
                          total: quotationDraft.total,
                          createdAt: DateTime.now(),
                          status: 'borrador',
                        );

                        try {
                          await quotationNotifier.updateQuotation(quotation);

                          // Limpiar el draft
                          ref.read(quotationDraftProvider.notifier).clear();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cotización actualizada exitosamente',
                                ),
                              ),
                            );
                            context.go('/home');
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al guardar: ${e.toString()}',
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
