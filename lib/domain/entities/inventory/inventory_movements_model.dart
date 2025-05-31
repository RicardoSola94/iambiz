import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryMovement_model {
  final String id;
  final String type; // "entrada" o "salida"
  final int quantity;
  final DateTime date;
  final String note;
  final String? relatedTo;

  InventoryMovement_model({
    required this.id,
    required this.type,
    required this.quantity,
    required this.date,
    required this.note,
    this.relatedTo,
  });

  factory InventoryMovement_model.fromMap(String id, Map<String, dynamic> map) {
    return InventoryMovement_model(
      id: id,
      type: map['type'],
      quantity: map['quantity'],
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'] ?? '',
      relatedTo: map['relatedTo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'quantity': quantity,
      'date': date,
      'note': note,
      'relatedTo': relatedTo,
    };
  }

  InventoryMovement_model copyWith({
    String? id,
    String? type,
    int? quantity,
    DateTime? date,
    String? note,
    String? relatedTo,
  }) {
    return InventoryMovement_model(
      id: id ?? this.id,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      note: note ?? this.note,
      relatedTo: relatedTo ?? this.relatedTo,
    );
  }
}
