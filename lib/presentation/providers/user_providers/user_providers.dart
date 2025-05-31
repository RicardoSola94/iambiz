import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iambiz/domain/entities/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth_providers/auth_providers.dart';

part 'user_providers.g.dart';

@Riverpod(keepAlive: true)
Future<UserModel?> userData(Ref ref) async {
  final uid = ref.watch(userIdProvider);
  if (uid == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!doc.exists) return null;

  return UserModel.fromMap(doc.data()!);
}

@Riverpod(keepAlive: true)
Future<String> userName(Ref ref, int id) async {
  final userAsync = await ref.watch(
    userDataProvider.future,
  ); // Esperamos el resultado del `userDataProvider`

  return userAsync?.name ?? '';
}
