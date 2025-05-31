import '../inventory/inventory_model.dart';

class ProductoCotizado {
  final String id;
  final String name;
  final double purchasePrice;
  final int quantity;

  ProductoCotizado({
    required this.id,
    required this.name,
    required this.purchasePrice,
    required this.quantity,
  });

  factory ProductoCotizado.fromProducto(InventoryModel producto, int quantity) {
    return ProductoCotizado(
      id: producto.id,
      name: producto.name,
      purchasePrice: producto.purchasePrice,
      quantity: quantity,
    );
  }

  factory ProductoCotizado.fromMap(Map<String, dynamic> data) {
    return ProductoCotizado(
      id: data['id'],
      name: data['name'],
      purchasePrice: (data['purchasePrice'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'purchasePrice': purchasePrice,
      'quantity': quantity,
    };
  }

  ProductoCotizado copyWith({
    String? id,
    String? name,
    double? purchasePrice,
    int? quantity,
  }) {
    return ProductoCotizado(
      id: id ?? this.id,
      name: name ?? this.name,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductoCotizado && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
