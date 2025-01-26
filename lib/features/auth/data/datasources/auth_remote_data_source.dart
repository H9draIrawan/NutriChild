import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> register(String email, String password, String username);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        throw ServerException(
            message: 'Silakan verifikasi email Anda terlebih dahulu');
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw ServerException(message: 'Data pengguna tidak ditemukan');
      }

      final userData = userDoc.data()!;

      return UserModel(
        id: userCredential.user!.uid,
        email: userData['email'],
        username: userData['username'],
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Terjadi kesalahan');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> register(String email, String password, String username) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: 'Gagal membuat user');
      }

      await userCredential.user!.sendEmailVerification();

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'email': email, 'username': username});
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Terjadi kesalahan');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(message: 'Gagal logout');
    }
  }
}
