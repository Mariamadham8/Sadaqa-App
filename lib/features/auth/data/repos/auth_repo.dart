import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadaqa_app/core/error/app_error.dart';

abstract class AuthRepository {
  Future<Either<AppError, User>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AppError, User>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<AppError, User>> signInWithGoogle();

  Future<Either<AppError, void>> signOut();

  User? getCurrentUser();

  Stream<User?> get authStateChanges;
}
