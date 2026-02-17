enum AuthMode { login, signup }

abstract class AuthEvent {}

class AuthEmailChanged extends AuthEvent {
  final String email;
  AuthEmailChanged(this.email);
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  AuthPasswordChanged(this.password);
}

class AuthTogglePasswordVisibility extends AuthEvent {}

class AuthSubmitted extends AuthEvent {} // ejecuta login o signup según el modo

class AuthResetPasswordRequested extends AuthEvent {} // usa el email actual del estado