/// Form validation utilities for the Flow EdTech Platform
///
/// Provides reusable validators for common input fields:
/// - Email validation
/// - Password strength validation
/// - Phone number validation
/// - Name validation
/// - URL validation
/// - Required field validation
///
/// Usage example:
/// ```dart
/// TextFormField(
///   validator: Validators.email,
///   // or combine validators:
///   validator: (value) => Validators.compose([
///     Validators.required('Email is required'),
///     Validators.email,
///   ])(value),
/// )
/// ```

class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password strength
  /// Requirements: 8+ characters, uppercase, lowercase, number
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));

    if (!hasUppercase || !hasLowercase || !hasDigit) {
      return 'Password must contain uppercase, lowercase, and number';
    }

    return null;
  }

  /// Validates password with optional special character requirement
  static String? passwordStrict(String? value) {
    final baseValidation = password(value);
    if (baseValidation != null) return baseValidation;

    bool hasSpecialChar = value!.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (!hasSpecialChar) {
      return 'Password must contain a special character';
    }

    return null;
  }

  /// Validates that passwords match
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }

      if (value != password) {
        return 'Passwords do not match';
      }

      return null;
    };
  }

  /// Validates phone number (international format)
  /// Supports formats: +254712345678, 254712345678, 0712345678
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // International format (e.g., +254712345678)
    if (cleanNumber.startsWith('+')) {
      if (cleanNumber.length < 10 || cleanNumber.length > 15) {
        return 'Please enter a valid phone number';
      }
      return null;
    }

    // Country code without + (e.g., 254712345678)
    if (cleanNumber.length >= 10 && cleanNumber.length <= 15) {
      if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
        return 'Phone number must contain only digits';
      }
      return null;
    }

    return 'Please enter a valid phone number';
  }

  /// Validates Kenyan phone number specifically (M-Pesa format)
  /// Format: 254712345678 or 0712345678
  static String? kenyanPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // 254 format
    if (cleanNumber.startsWith('254')) {
      if (!RegExp(r'^254[0-9]{9}$').hasMatch(cleanNumber)) {
        return 'Please enter a valid Kenyan phone number (254...)';
      }
      return null;
    }

    // 07/01 format
    if (cleanNumber.startsWith('0')) {
      if (!RegExp(r'^0[0-9]{9}$').hasMatch(cleanNumber)) {
        return 'Please enter a valid Kenyan phone number (07...)';
      }
      return null;
    }

    return 'Please enter a valid Kenyan phone number';
  }

  /// Validates name (minimum length, letters only)
  static String? name(String? value, {int minLength = 2}) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }

    if (value.trim().length < minLength) {
      return 'Name must be at least $minLength characters';
    }

    // Allow letters, spaces, hyphens, and apostrophes
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'Name can only contain letters';
    }

    return null;
  }

  /// Validates full name (requires at least 2 words)
  static String? fullName(String? value) {
    final baseValidation = name(value, minLength: 3);
    if (baseValidation != null) return baseValidation;

    final words = value!.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'Please enter your full name (first and last name)';
    }

    return null;
  }

  /// Validates URL format
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)$',
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validates required field with custom message
  static String? Function(String?) required([String? message]) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  /// Validates minimum length
  static String? Function(String?) minLength(int length, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null; // Let required validator handle empty
      }

      if (value.length < length) {
        return '${fieldName ?? 'This field'} must be at least $length characters';
      }

      return null;
    };
  }

  /// Validates maximum length
  static String? Function(String?) maxLength(int length, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null; // Let required validator handle empty
      }

      if (value.length > length) {
        return '${fieldName ?? 'This field'} must not exceed $length characters';
      }

      return null;
    };
  }

  /// Validates numeric input
  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  /// Validates positive number
  static String? positiveNumber(String? value) {
    final baseValidation = number(value);
    if (baseValidation != null) return baseValidation;

    final numValue = double.parse(value!);
    if (numValue <= 0) {
      return 'Please enter a positive number';
    }

    return null;
  }

  /// Validates number within range
  static String? Function(String?) numberInRange(double min, double max) {
    return (String? value) {
      final baseValidation = number(value);
      if (baseValidation != null) return baseValidation;

      final numValue = double.parse(value!);
      if (numValue < min || numValue > max) {
        return 'Please enter a number between $min and $max';
      }

      return null;
    };
  }

  /// Validates date is not in the future
  static String? notFutureDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }

    if (value.isAfter(DateTime.now())) {
      return 'Date cannot be in the future';
    }

    return null;
  }

  /// Validates date is not in the past
  static String? notPastDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }

    if (value.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Date cannot be in the past';
    }

    return null;
  }

  /// Validates GPA (0.0 - 4.0)
  static String? gpa(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter GPA';
    }

    final gpaValue = double.tryParse(value);
    if (gpaValue == null) {
      return 'Please enter a valid GPA';
    }

    if (gpaValue < 0.0 || gpaValue > 4.0) {
      return 'GPA must be between 0.0 and 4.0';
    }

    return null;
  }

  /// Composes multiple validators into one
  /// Returns the first error found, or null if all pass
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  /// Validates academic year format (e.g., "2023-2024")
  static String? academicYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter academic year';
    }

    final yearRegex = RegExp(r'^(\d{4})-(\d{4})$');
    final match = yearRegex.firstMatch(value);

    if (match == null) {
      return 'Please enter valid format (e.g., 2023-2024)';
    }

    final startYear = int.parse(match.group(1)!);
    final endYear = int.parse(match.group(2)!);

    if (endYear != startYear + 1) {
      return 'End year must be one year after start year';
    }

    return null;
  }

  /// Validates postal/ZIP code
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter postal code';
    }

    // Allow alphanumeric with optional spaces/hyphens
    if (!RegExp(r'^[a-zA-Z0-9\s\-]{3,10}$').hasMatch(value)) {
      return 'Please enter a valid postal code';
    }

    return null;
  }

  /// Validates ID number (flexible format)
  static String? idNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter ID number';
    }

    // Allow alphanumeric, 5-20 characters
    if (!RegExp(r'^[a-zA-Z0-9]{5,20}$').hasMatch(value)) {
      return 'Please enter a valid ID number';
    }

    return null;
  }
}
