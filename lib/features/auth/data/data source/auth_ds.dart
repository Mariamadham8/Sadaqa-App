import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/core/services/auth/firebase_auth_servide.dart';
import 'package:sadaqa_app/core/services/fireStore/user_service.dart';

class AuthDataSource {
  final FirebaseAuthService _authService;
  final UserService _userService;

  AuthDataSource({
    required FirebaseAuthService authService,
    required UserService userService,
  }) : _authService = authService,
       _userService = userService;

  Future<Either<AppError, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return const Left(UnknownError());
    }
  }

  Future<Either<AppError, User>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      final user = credential.user!;

      // Save user to Firestore
      await _userService.createUser(uid: user.uid, name: name, email: email);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return const Left(UnknownError());
    }
  }

  Future<Either<AppError, User>> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      final user = credential.user!;

      // Save user to Firestore if new
      final existing = await _userService.getUser(user.uid);
      if (existing == null) {
        await _userService.createUser(
          uid: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
        );
      }

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      if (e.toString().contains('aborted')) {
        return const Left(GoogleSignInCancelledError());
      }
      return const Left(UnknownError());
    }
  }

  Future<Either<AppError, void>> signOut() async {
    try {
      await _authService.signOut();
      return const Right(null);
    } catch (_) {
      return const Left(UnknownError());
    }
  }

  User? getCurrentUser() => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Map Firebase errors to AppError
  AppError _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const InvalidEmailError();
      case 'wrong-password':
      case 'invalid-credential':
        return const WrongPasswordError();
      case 'user-not-found':
        return const UserNotFoundError();
      case 'email-already-in-use':
        return const EmailAlreadyInUseError();
      case 'weak-password':
        return const WeakPasswordError();
      case 'network-request-failed':
        return const NetworkError();
      default:
        return UnknownError(e.message ?? 'حدث خطأ غير متوقع');
    }
  }
}
