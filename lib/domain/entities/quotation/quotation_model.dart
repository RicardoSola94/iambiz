import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iambiz/domain/entities/clientes/clientes_model.dart';
import 'package:iambiz/domain/entities/producto_cotizado.dart/producto_cotizado_model.dart';
import 'package:iambiz/domain/entities/services/service_model.dart';

class QuotationModel {
  final String id;
  final String name;
  final ClienteModel client;
  final List<ServiceModel> servicios;
  final List<ProductoCotizado> productos;
  final double total;
  final DateTime createdAt;
  final String status;

  QuotationModel({
    required this.id,
    required this.name,
    required this.client,
    required this.servicios,
    required this.productos,
    required this.total,
    required this.createdAt,
    required this.status,
  });

  factory QuotationModel.fromMap(Map<String, dynamic> data, String id) {
    final clientData = data['client'];
    if (clientData == null || clientData is! Map<String, dynamic>) {
      throw Exception('Invalid or missing client data for quotation $id');
    }

    return QuotationModel(
      id: id,
      name: data['name'] ?? '',
      client: ClienteModel.fromMap(clientData, clientData['id'] ?? ''),
      servicios:
          (data['servicios'] as List<dynamic>?)?.map((s) {
            if (s is! Map<String, dynamic>) {
              throw Exception('Invalid servicio item');
            }
            return ServiceModel.fromMap(s, s['id'] ?? '');
          }).toList() ??
          [],
      productos:
          (data['productos'] as List<dynamic>?)?.map((p) {
            if (p is! Map<String, dynamic>) {
              throw Exception('Invalid producto item');
            }
            return ProductoCotizado.fromMap(p);
          }).toList() ??
          [],
      total: (data['total'] ?? 0).toDouble(),
      createdAt:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      status: data['status'] ?? 'borrador',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'client': client.toMap(),
      'servicios': servicios.map((s) => s.toMap()).toList(),
      'productos': productos.map((p) => p.toMap()).toList(),
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  double get totalServices =>
      servicios.fold(0, (sum, s) => sum + (s.price ?? 0));

  double get totalProducts => productos.fold(
    0,
    (sum, p) => sum + (p.purchasePrice ?? 0) * (p.quantity ?? 1),
  );
}
