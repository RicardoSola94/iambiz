import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iambiz/domain/entities/services/service_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.g.dart';

@riverpod
class Services extends _$Services {
  @override
  FutureOr<List<ServiceModel>> build() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('services')
            .get();

    return snapshot.docs
        .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addService(ServiceModel service) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('services')
        .add(service.toMap());

    final newService = service.copyWith(id: docRef.id);

    state = AsyncData([...state.value ?? [], newService]);
  }

  Future<void> deleteService(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('services')
        .doc(id)
        .delete();

    state = AsyncData(
      state.value!.where((service) => service.id != id).toList(),
    );
  }

  Future<void> updateService(ServiceModel updated) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('services')
        .doc(updated.id)
        .update(updated.toMap());

    final updatedList =
        state.value!.map((s) => s.id == updated.id ? updated : s).toList();

    state = AsyncData(updatedList);
  }
}
