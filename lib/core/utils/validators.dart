abstract class FieldValidators {
  // ── Email ────────────────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  // ── Password ─────────────────────────────────────────────────────────────
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'At least 8 characters required';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include at least one uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Include at least one lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include at least one number';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Include at least one special character';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Please confirm your password';
      if (value != password) return 'Passwords do not match';
      return null;
    };
  }

  // ── Name ─────────────────────────────────────────────────────────────────
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name is too short';
    if (!RegExp(r"^[a-zA-Z\u0600-\u06FF\s''\-]+$").hasMatch(value.trim())) {
      return 'Name contains invalid characters';
    }
    return null;
  }

  // ── Phone ─────────────────────────────────────────────────────────────────
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleaned)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  // ── Required (generic) ───────────────────────────────────────────────────
  static String? Function(String?) required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return '$fieldName is required';
      return null;
    };
  }

  // ── Min length ───────────────────────────────────────────────────────────
  static String? Function(String?) minLength(int min, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      if (value.trim().length < min) {
        return '${fieldName ?? 'This field'} must be at least $min characters';
      }
      return null;
    };
  }

  // ── Max length ───────────────────────────────────────────────────────────
  static String? Function(String?) maxLength(int max, {String? fieldName}) {
    return (String? value) {
      if (value != null && value.trim().length > max) {
        return '${fieldName ?? 'This field'} must be at most $max characters';
      }
      return null;
    };
  }

  // ── Amount (money) ───────────────────────────────────────────────────────
  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final cleaned = value.replaceAll(',', '.');
    final number = double.tryParse(cleaned);
    if (number == null) return 'Enter a valid amount';
    if (number <= 0) return 'Amount must be greater than zero';
    return null;
  }

  // ── URL ──────────────────────────────────────────────────────────────────
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional by default
    if (!RegExp(r'^https?://[^\s/$.?#].[^\s]*$').hasMatch(value.trim())) {
      return 'Enter a valid URL';
    }
    return null;
  }
}