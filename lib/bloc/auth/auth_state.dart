import 'package:agrimarket/bloc/auth/auth_event.dart';

class AuthState {
  final AuthMode mode;
  final String email;
  final String password;
  final bool passwordVisible;
  final bool submitting;
  final String? errorMessage;
  final bool success; // true si login/signup OK

  const AuthState({
    required this.mode,
    required this.email,
    required this.password,
    required this.passwordVisible,
    required this.submitting,
    required this.errorMessage,
    required this.success,
  });

  factory AuthState.initial(AuthMode mode) => AuthState(
    mode: mode,
    email: '',
    password: '',
    passwordVisible: false,
    submitting: false,
    errorMessage: null,
    success: false,
  );

  AuthState copyWith({
    AuthMode? mode,
    String? email,
    String? password,
    bool? passwordVisible,
    bool? submitting,
    String? errorMessage,
    bool? success,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      submitting: submitting ?? this.submitting,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }
}