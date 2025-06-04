import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iambiz/domain/entities/inventory/inventory_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inventory_providers.g.dart'; // Asegúrate de tener tu userIdProvider

@Riverpod(keepAlive: true)
class Inventory extends _$Inventory {
  @override
  Future<List<InventoryModel>> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await Future.delayed(const Duration(seconds: 1));

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('inventory')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => InventoryModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addItem(InventoryModel item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');
    state = const AsyncLoading();

    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('inventory')
        .add(item.copyWith(createdAt: DateTime.now()).toMap());

    final newItem = item.copyWith(id: docRef.id);

    state = AsyncData([...state.value ?? [], newItem]);
  }

  Future<void> updateItem(InventoryModel item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');
    state = const AsyncLoading();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('inventory')
        .doc(item.id)
        .update(item.toMap());

    state = AsyncData([
      for (final i in state.value ?? [])
        if (i.id == item.id) item else i,
    ]);
  }

  Future<void> deleteItem(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    state = const AsyncLoading();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('inventory')
        .doc(id)
        .delete();

    state = AsyncData((state.value ?? []).where((i) => i.id != id).toList());
  }
}
