import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String username);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
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

      if (userCredential.user == null) {
        throw ServerException(message: 'User tidak ditemukan');
      }

      final userData = await _getUserData(userCredential.user!.uid);
      return userData;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(
        message: _getMessageFromErrorCode(e.code),
      );
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan saat login');
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      // Check if username already exists
      final usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        throw ServerException(message: 'Username sudah digunakan');
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: 'Gagal membuat user');
      }

      // Create user document in Firestore
      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        username: username,
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(
        message: _getMessageFromErrorCode(e.code),
      );
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan saat registrasi');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan saat logout');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      return _getUserData(currentUser.uid);
    }
    return null;
  }

  Future<UserModel> _getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        throw ServerException(message: 'Data user tidak ditemukan');
      }

      return UserModel.fromJson({
        'id': docSnapshot.id,
        ...docSnapshot.data()!,
      });
    } catch (e) {
      throw ServerException(message: 'Gagal mengambil data user');
    }
  }

  String _getMessageFromErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'weak-password':
        return 'Password terlalu lemah';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }
}
