import 'package:iambiz/domain/entities/quotation/quotation_draft.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.Document> generateQuotationPdf(QuotationDraftModel draft) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Resumen de Cotización',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Cliente:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(draft.client?.nombre ?? 'No seleccionado'),
            pw.Text(draft.client?.correo ?? ''),
            pw.SizedBox(height: 20),

            pw.Text(
              'Servicios:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            if (draft.servicios.isEmpty)
              pw.Text('No hay servicios')
            else
              pw.Column(
                children:
                    draft.servicios
                        .map(
                          (s) => pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(s.name),
                              pw.Text('\$${s.price.toStringAsFixed(2)}'),
                            ],
                          ),
                        )
                        .toList(),
              ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Total servicios: \$${draft.totalServices.toStringAsFixed(2)}',
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Productos:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            if (draft.productos.isEmpty)
              pw.Text('No hay productos')
            else
              pw.Column(
                children:
                    draft.productos
                        .map(
                          (p) => pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('${p.name} x${p.quantity}'),
                              pw.Text(
                                '\$${(p.purchasePrice * (p.quantity ?? 1)).toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Total productos: \$${draft.totalProducts.toStringAsFixed(2)}',
            ),
            pw.SizedBox(height: 20),

            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total general:',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '\$${draft.total.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return pdf;
}
