import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/auth/data/repos/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  AuthCubit(this._repository) : super(AuthInitial());

  // Check if user already logged in on app start
  void checkCurrentUser() {
    final user = _repository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // Sign in with email & password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (error) => emit(AuthFailure(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  // Sign up with email & password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());

    final result = await _repository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );

    result.fold(
      (error) => emit(AuthFailure(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    final result = await _repository.signInWithGoogle();

    result.fold(
      (error) => emit(AuthFailure(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  // Sign out
  Future<void> signOut() async {
    emit(AuthLoading());

    final result = await _repository.signOut();

    result.fold(
      (error) => emit(AuthFailure(error)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
