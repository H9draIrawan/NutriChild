import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrichild/bloc/auth/auth_event.dart';
import 'package:nutrichild/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(InitialAuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        UserCredential signIn = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        DocumentSnapshot user =
            await _firestore.collection('users').doc(signIn.user!.uid).get();
        emit(LoginAuthState(user['username'], user['email']));
      } catch (e) {
        emit(ErrorAuthState(e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        String uid = userCredential.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'username': event.username,
          'email': event.email,
        });

        emit(RegisterAuthState());
      } catch (e) {
        emit(ErrorAuthState(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await _firebaseAuth.signOut();
      } catch (e) {
        emit(ErrorAuthState(e.toString()));
      }
    });
  }
}
