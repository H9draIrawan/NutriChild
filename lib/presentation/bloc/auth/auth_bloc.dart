import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/domain/usecases/auth/login.dart';
import 'package:nutrichild/domain/usecases/auth/register.dart';
import 'package:nutrichild/domain/usecases/auth/logout.dart';
import 'package:nutrichild/domain/usecases/auth/reset_password.dart';
import 'package:nutrichild/domain/usecases/auth/change_password.dart';
import 'package:nutrichild/domain/usecases/auth/delete_account.dart';
import 'package:nutrichild/domain/usecases/auth/update_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final Logout _logout;
  final ResetPassword _resetPassword;
  final ChangePassword _changePassword;
  final DeleteAccount _deleteAccount;
  final UpdateUser _updateUser;

  AuthBloc({
    required Login login,
    required Register register,
    required Logout logout,
    required ResetPassword resetPassword,
    required ChangePassword changePassword,
    required DeleteAccount deleteAccount,
    required UpdateUser updateUser,
  })  : _login = login,
        _register = register,
        _logout = logout,
        _resetPassword = resetPassword,
        _changePassword = changePassword,
        _deleteAccount = deleteAccount,
        _updateUser = updateUser,
        super(InitialAuthState()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
    on<DeleteAccountEvent>(_onDeleteAccountEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
  }

  Future<void> _onLoginEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _login.call(event.email, event.password);

    result.fold((failure) => emit(ErrorAuthState(failure.toString())),
        (user) => emit(LoginAuthState(user)));
  }

  Future<void> _onRegisterEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _register.call(
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

    final result = await _logout.call();

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(LogoutAuthState()),
    );
  }

  Future<void> _onResetPasswordEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _resetPassword.call(event.email);

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(ResetPasswordAuthState()),
    );
  }

  Future<void> _onChangePasswordEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _changePassword.call(event.email, event.password);

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(ChangePasswordAuthState()),
    );
  }

  Future<void> _onDeleteAccountEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _deleteAccount.call();

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(DeleteAccountAuthState()),
    );
  }

  Future<void> _onUpdateUserEvent(event, emit) async {
    emit(LoadingAuthState());

    final result = await _updateUser.call(event.user);

    result.fold(
      (failure) => emit(ErrorAuthState(failure.toString())),
      (_) => emit(UpdateUserAuthState()),
    );
  }
}
