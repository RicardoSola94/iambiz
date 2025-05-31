import 'package:iambiz/domain/entities/producto_cotizado.dart/producto_cotizado_model.dart';

import '../clientes/clientes_model.dart';
import '../services/service_model.dart';

class QuotationDraftModel {
  final ClienteModel? client;
  final List<ProductoCotizado> productos;
  final List<ServiceModel> servicios;

  QuotationDraftModel({
    this.client,
    this.productos = const [],
    this.servicios = const [],
  });

  factory QuotationDraftModel.empty() => QuotationDraftModel();

  QuotationDraftModel copyWith({
    ClienteModel? client,
    List<ProductoCotizado>? productos,
    List<ServiceModel>? servicios,
  }) {
    return QuotationDraftModel(
      client: client ?? this.client,
      productos: productos ?? this.productos,
      servicios: servicios ?? this.servicios,
    );
  }

  double get totalServices =>
      servicios.fold(0, (sum, s) => sum + (s.price ?? 0));

  double get totalProducts => productos.fold(
    0,
    (sum, p) => sum + (p.purchasePrice ?? 0) * (p.quantity ?? 1),
  );

  double get total => totalServices + totalProducts;
}
