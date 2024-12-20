import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrichild/bloc/auth/auth_event.dart';
import 'package:nutrichild/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(InitialAuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        emit(AuthenticatedAuthState());
      } catch (e) {
        emit(ErrorAuthState(e.toString()));
      }
      emit(LoadedAuthState());
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
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': event.username,
          'email': event.email,
          'uid': uid,
        });

        emit(AuthenticatedAuthState());
      } catch (e) {
        emit(ErrorAuthState(e.toString()));
      }
      emit(LoadedAuthState());
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
