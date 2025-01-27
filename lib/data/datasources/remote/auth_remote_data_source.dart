import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> register(String email, String password, String username);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<void> changePassword(String email, String password);
  Future<void> updateUser(UserModel user);
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw AuthException('Email and password cannot be empty');
      } else if (!email.contains('@')) {
        throw AuthException('Invalid email');
      } else if (password.length < 6) {
        throw AuthException('Password must be at least 6 characters long');
      }

      final userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .onError((error, stackTrace) {
        throw UserNotFoundException('Email or password is incorrect');
      });

      if (!userCredential.user!.emailVerified) {
        throw EmailNotVerifiedException('Email not verified');
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel(
        id: userDoc.id,
        email: userDoc['email'],
        username: userDoc['username'],
      );
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on UserNotFoundException catch (e) {
      throw UserNotFoundException(e.message);
    } on EmailNotVerifiedException catch (e) {
      throw EmailNotVerifiedException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> register(String email, String password, String username) async {
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        throw AuthException('Email, password, and username cannot be empty');
      } else if (!email.contains('@')) {
        throw AuthException('Invalid email');
      } else if (password.length < 6) {
        throw AuthException('Password must be at least 6 characters long');
      }

      final userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .onError((error, stackTrace) {
        throw UserAlreadyExistsException('User already exists');
      });

      await userCredential.user!.sendEmailVerification();
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'email': email, 'username': username});
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on UserAlreadyExistsException catch (e) {
      throw UserAlreadyExistsException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Failed to logout');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw ServerException('Failed to reset password');
    }
  }

  @override
  Future<void> changePassword(String email, String password) async {
    await _firebaseAuth.currentUser!.updatePassword(password);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }

  @override
  Future<void> deleteAccount() async {
    await _firebaseAuth.currentUser!.delete();
  }
}
