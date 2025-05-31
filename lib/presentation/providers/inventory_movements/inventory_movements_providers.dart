import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iambiz/domain/entities/inventory/inventory_movements_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers.dart';

part 'inventory_movements_providers.g.dart';

@Riverpod(keepAlive: true)
class InventoryMovements extends _$InventoryMovements {
  late final FirebaseFirestore _firestore;
  late final String userId;

  @override
  Future<List<InventoryMovement_model>> build(String itemId) async {
    _firestore = FirebaseFirestore.instance;
    userId = ref.watch(userIdProvider) ?? '';

    if (userId.isEmpty) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('inventory')
            .doc(itemId)
            .collection('movements')
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => InventoryMovement_model.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addMovement(
    String itemId,
    InventoryMovement_model movement,
  ) async {
    state = const AsyncLoading();

    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .doc(itemId)
        .collection('movements')
        .add(movement.copyWith(date: DateTime.now()).toMap());

    final newMovement = movement.copyWith(id: docRef.id);

    // Actualiza el estado con el nuevo movimiento
    state = AsyncData([...state.value ?? [], newMovement]);
  }

  Future<void> deleteMovement(String itemId, String movementId) async {
    state = const AsyncLoading();

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .doc(itemId)
        .collection('movements')
        .doc(movementId)
        .delete();

    state = AsyncData(
      (state.value ?? []).where((m) => m.id != movementId).toList(),
    );
  }
}
