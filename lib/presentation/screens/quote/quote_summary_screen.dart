import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/presentation/providers/quotations/quotation_draft_providers.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../domain/entities/quotation/quotation_model.dart';
import '../../providers/quotations/quotations_providers.dart';
import '../widgets/generar_quotation_pdf.dart';

class QuoteSummaryScreen extends ConsumerWidget {
  const QuoteSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(quotationDraftProvider);
    final quotationNotifier = ref.read(quotationProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
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
            top: -((1 / 4) * 500),
            right: -((1 / 4) * 500),
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
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 60),

                      SizedBox(
                        height: 50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Center(
                              child: Text(
                                "Resumen de Cotización",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
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
                              Text(
                                'Cliente',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              draft.client != null
                                  ? Text(
                                    '${draft.client!.nombre}\n${draft.client!.correo ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                  : Text(
                                    'No se ha seleccionado cliente',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
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
                              Text(
                                'Servicios',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (draft.servicios.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'No se han añadido servicios',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                )
                              else
                                ...draft.servicios.map(
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
                                  'Total servicios: \$${draft.totalServices.toStringAsFixed(2)}',
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
                              Text(
                                'Productos',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (draft.productos.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'No se han añadido productos',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                )
                              else
                                ...draft.productos.map(
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
                                  'Total productos: \$${draft.totalProducts.toStringAsFixed(2)}',
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
                                '\$${draft.total.toStringAsFixed(2)}',
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
                          // Guardar la cotización
                          if (draft.client == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Debes seleccionar un cliente'),
                              ),
                            );
                            return;
                          }

                          // Generar el PDF
                          final pdf = await generateQuotationPdf(draft);

                          // Mostrar vista previa para imprimir o guardar PDF
                          await Printing.layoutPdf(
                            onLayout:
                                (PdfPageFormat format) async => pdf.save(),
                          );

                          final quotation = QuotationModel(
                            id: '', // Firebase lo asignará
                            name: 'Cotización de ${draft.client!.nombre}',
                            client: draft.client!,
                            servicios: draft.servicios,
                            productos: draft.productos,
                            total: draft.total,
                            createdAt: DateTime.now(),
                            status: 'borrador',
                          );

                          await quotationNotifier.addQuotation(quotation);

                          // Limpiar el draft
                          ref.read(quotationDraftProvider.notifier).clear();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cotización guardada exitosamente',
                                ),
                              ),
                            );

                            // Opcional: limpiar el draft o navegar
                            context.go('/home');
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                    ]),
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
