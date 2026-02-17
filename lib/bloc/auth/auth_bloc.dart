import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc({required AuthRepository repository, required AuthMode mode})
      : repo = repository,
        super(AuthState.initial(mode)) {
    on<AuthEmailChanged>((e, emit) => emit(state.copyWith(email: e.email, errorMessage: null)));
    on<AuthPasswordChanged>((e, emit) => emit(state.copyWith(password: e.password, errorMessage: null)));
    on<AuthTogglePasswordVisibility>((e, emit) => emit(state.copyWith(passwordVisible: !state.passwordVisible)));
    on<AuthSubmitted>(_onSubmitted);
    on<AuthResetPasswordRequested>(_onResetPassword);
  }

  Future<void> _onSubmitted(AuthSubmitted e, Emitter<AuthState> emit) async {
    if (state.email.isEmpty || state.password.length < 6) {
      emit(state.copyWith(errorMessage: 'Verifica tu correo y que la contraseña tenga al menos 6 caracteres.'));
      return;
    }
    emit(state.copyWith(submitting: true, errorMessage: null, success: false));
    try {
      if (state.mode == AuthMode.login) {
        await repo.signIn(state.email, state.password);
      } else {
        await repo.signUp(state.email, state.password);
      }
      emit(state.copyWith(submitting: false, success: true));
    } on FirebaseAuthException catch (ex) {
      emit(state.copyWith(submitting: false, errorMessage: _mapAuthError(ex)));
    } catch (ex) {
      emit(state.copyWith(submitting: false, errorMessage: 'Ocurrió un error inesperado.'));
    }
  }

  Future<void> _onResetPassword(AuthResetPasswordRequested e, Emitter<AuthState> emit) async {
    if (state.email.isEmpty) {
      emit(state.copyWith(errorMessage: 'Ingresa tu correo para enviar el enlace de recuperación.'));
      return;
    }
    emit(state.copyWith(submitting: true, errorMessage: null));
    try {
      await repo.sendPasswordReset(state.email);
      emit(state.copyWith(submitting: false, errorMessage: 'Te enviamos un correo para restablecer la contraseña.'));
    } on FirebaseAuthException catch (ex) {
      emit(state.copyWith(submitting: false, errorMessage: _mapAuthError(ex)));
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Correo inválido.';
      case 'user-disabled':
        return 'Usuario deshabilitado.';
      case 'user-not-found':
        return 'Usuario no encontrado.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'weak-password':
        return 'Contraseña muy débil (usa 6+ caracteres).';
      default:
        return 'Error: ${e.message ?? e.code}';
    }
  }
}