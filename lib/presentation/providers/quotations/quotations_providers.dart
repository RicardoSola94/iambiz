import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/quotation/quotation_model.dart';

part 'quotations_providers.g.dart';

@Riverpod(keepAlive: true)
class Quotation extends _$Quotation {
  @override
  Future<List<QuotationModel>> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('quotations')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => QuotationModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addQuotation(QuotationModel quotation) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final ref =
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('quotations')
            .doc();

    await ref.set(quotation.toMap());

    state = AsyncValue.data([
      QuotationModel(
        id: ref.id,
        name: quotation.name,
        client: quotation.client,
        servicios: quotation.servicios,
        productos: quotation.productos,
        total: quotation.total,
        createdAt: quotation.createdAt,
        status: quotation.status,
      ),
      ...state.value ?? [],
    ]);
  }

  Future<void> deleteQuotation(String id) async {
    await FirebaseFirestore.instance.collection('quotations').doc(id).delete();
    state = AsyncValue.data(
      state.value?.where((q) => q.id != id).toList() ?? [],
    );
  }

  Future<QuotationModel?> quotationById(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await Future.delayed(const Duration(seconds: 2));

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('quotations')
            .doc(id)
            .get();

    if (!doc.exists) return null;

    return QuotationModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> updateQuotation(QuotationModel updatedQuotation) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('quotations')
        .doc(updatedQuotation.id);

    await ref.update(updatedQuotation.toMap());

    // Opcional: actualizar el estado local
    final currentList = state.value ?? [];
    final updatedList =
        currentList.map((q) {
          return q.id == updatedQuotation.id ? updatedQuotation : q;
        }).toList();

    state = AsyncValue.data(updatedList);
  }
}
