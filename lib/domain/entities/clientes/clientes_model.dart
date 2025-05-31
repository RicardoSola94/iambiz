import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteModel {
  final String id;
  final String nombre;
  final String telefono;
  final String correo;
  final DateTime createdAt;
  final String estado; // "activo", "inactivo", "pendiente"

  ClienteModel({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.createdAt,
    required this.estado,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map, String id) {
    return ClienteModel(
      id: id,
      nombre: map['nombre'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      estado: map['estado'] ?? 'activo',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'correo': correo,
      'createdAt': Timestamp.fromDate(createdAt),
      'estado': estado,
    };
  }

  ClienteModel copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? correo,
    DateTime? createdAt,
    String? estado,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      createdAt: createdAt ?? this.createdAt,
      estado: estado ?? this.estado,
    );
  }
}
