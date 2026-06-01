part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  AuthLoading();
}

// Success — user logged in
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

// User not logged in
class AuthUnauthenticated extends AuthState {
  AuthUnauthenticated();
}

// Error
class AuthFailure extends AuthState {
  final AppError error;
  AuthFailure(this.error);
}
