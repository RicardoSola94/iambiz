import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryModel {
  final String id;
  final String name;
  final String category;
  final String unit;
  final int quantity;
  final int minQuantity;
  final double purchasePrice;
  final double? salePrice;

  final DateTime createdAt;

  InventoryModel({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.quantity,
    required this.minQuantity,
    required this.purchasePrice,
    required this.salePrice,
    required this.createdAt,
  });

  InventoryModel copyWith({
    String? id,
    String? name,
    String? category,
    String? unit,
    int? quantity,
    int? minQuantity,
    double? purchasePrice,
    double? salePrice,
    DateTime? createdAt,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory InventoryModel.fromMap(String id, Map<String, dynamic> map) {
    return InventoryModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      unit: map['unit'] ?? '',
      quantity: map['quantity'] ?? 0,
      minQuantity: map['minQuantity'] ?? 0,
      purchasePrice: (map['purchasePrice'] ?? 0).toDouble(),
      salePrice:
          map['salePrice'] != null
              ? (map['salePrice'] as num).toDouble()
              : null,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'unit': unit,
      'quantity': quantity,
      'minQuantity': minQuantity,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'createdAt': createdAt,
    };
  }
}
