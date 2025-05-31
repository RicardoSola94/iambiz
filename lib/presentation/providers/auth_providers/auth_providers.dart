import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<User?> authState(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
String? userId(Ref ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return user?.uid;
}

@riverpod
class Auth extends _$Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  FutureOr<User?> build() {
    return _auth.currentUser;
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    state = const AsyncLoading();
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Usuario no disponible');

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      state = AsyncData(user);
    } catch (e) {
      state = const AsyncData(null);
      throw Exception('Error en el registro: $e');
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      state = AsyncData(user);
    } catch (e) {
      state = const AsyncData(null);
      throw Exception('Error en el login: $e');
    }
  }
}

// @Riverpod(keepAlive: true)
// class User extends _$User {

//   @override
//   UserModel build() {
//     return getU;
//   }

//   void changeName(String name) {
//     state = name;
//   }
// }
