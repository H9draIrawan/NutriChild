import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/features/auth/domain/usecases/login.dart';
import 'package:nutrichild/features/auth/domain/usecases/register.dart';
import 'package:nutrichild/features/auth/domain/usecases/logout.dart';
import 'package:nutrichild/features/auth/domain/usecases/reset_password.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final Logout _logout;
  final ResetPassword _resetPassword;
  AuthBloc({
    required Login login,
    required Register register,
    required Logout logout,
    required ResetPassword resetPassword,
  })  : _login = login,
        _register = register,
        _logout = logout,
        _resetPassword = resetPassword,
        super(InitialAuthState()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
  }

  Future<void> _onLoginEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _login.execute(event.email, event.password);

    result.fold((failure) => emit(ErrorAuthState(failure.toString())),
        (user) => emit(LoginAuthState(user)));
  }

  Future<void> _onRegisterEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _register.execute(
      event.email,
      event.password,
      event.username,
    );

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(RegisterAuthState()),
    );
  }

  Future<void> _onLogoutEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _logout.execute();

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(LogoutAuthState()),
    );
  }

  Future<void> _onResetPasswordEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _resetPassword.execute(event.email);

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(ResetPasswordAuthState()),
    );
  }
}
