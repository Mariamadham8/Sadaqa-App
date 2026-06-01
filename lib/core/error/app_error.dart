class AppError {
  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
}

// Auth Errors
class InvalidEmailError extends AppError {
  const InvalidEmailError() : super('البريد الإلكتروني غير صحيح');
}

class WrongPasswordError extends AppError {
  const WrongPasswordError() : super('كلمة المرور غير صحيحة');
}

class UserNotFoundError extends AppError {
  const UserNotFoundError() : super('المستخدم غير موجود');
}

class EmailAlreadyInUseError extends AppError {
  const EmailAlreadyInUseError() : super('البريد الإلكتروني مستخدم بالفعل');
}

class WeakPasswordError extends AppError {
  const WeakPasswordError() : super('كلمة المرور ضعيفة جداً');
}

class GoogleSignInCancelledError extends AppError {
  const GoogleSignInCancelledError() : super('تم إلغاء تسجيل الدخول بـ Google');
}

// Network Errors
class NetworkError extends AppError {
  const NetworkError() : super('تحقق من اتصالك بالإنترنت');
}

// Firestore Errors
class NotFoundError extends AppError {
  const NotFoundError() : super('البيانات غير موجودة');
}

class PermissionDeniedError extends AppError {
  const PermissionDeniedError() : super('ليس لديك صلاحية للوصول');
}

// Unknown
class UnknownError extends AppError {
  const UnknownError([String message = 'حدث خطأ غير متوقع']) : super(message);
}
