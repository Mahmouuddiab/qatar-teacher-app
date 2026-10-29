class AppValidator {
  // Qatar Phone Validator: Handles 8 digits starting with 3, 4, 5, 6, 7 (supports optional +974 prefix if pasted)
  static String? phone(String? value, {String? requiredMsg}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Please enter your phone number';
    }

    // Remove spaces and dashes
    String cleanValue = value.replaceAll(RegExp(r'\s+|-'), '');

    // If the user pasted/typed +974 or 974, strip it out so we validate the 8 digits
    if (cleanValue.startsWith('+974')) {
      cleanValue = cleanValue.substring(4);
    } else if (cleanValue.startsWith('974')) {
      cleanValue = cleanValue.substring(3);
    }

    // Qatari numbers must be exactly 8 digits starting with 3, 4, 5, 6, or 7
    final qatarPhoneRegex = RegExp(r'^[34567]\d{7}$');

    if (!qatarPhoneRegex.hasMatch(cleanValue)) {
      return 'Invalid phone number (must be 8 digits starting with 3, 4, 5, 6, 7)';
    }

    return null;
  }

  // Full Name Validator
  static String? name(String? value, {String? requiredMsg}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Please enter your full name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  // Email Validator
  static String? email(String? value, {String? requiredMsg}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password Validator (Minimum 8 characters)
  static String? password(String? value, {String? requiredMsg}) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}