import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/auth/data/data%20source/auth_ds.dart';
import 'package:sadaqa_app/features/auth/data/repos/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<AppError, User>> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<Either<AppError, User>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) {
    return _dataSource.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<Either<AppError, User>> signInWithGoogle() {
    return _dataSource.signInWithGoogle();
  }

  @override
  Future<Either<AppError, void>> signOut() {
    return _dataSource.signOut();
  }

  @override
  User? getCurrentUser() => _dataSource.getCurrentUser();

  @override
  Stream<User?> get authStateChanges => _dataSource.authStateChanges;
}
