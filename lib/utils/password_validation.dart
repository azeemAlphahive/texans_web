/// Aligns with common backend rules (avoids generic "Invalid format" from API).
String? passwordPolicyError(String password) {
  if (password.length < 8) {
    return 'Password must be at least 8 characters long.';
  }
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must include at least one uppercase letter.';
  }
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must include at least one lowercase letter.';
  }
  if (!RegExp(r'[0-9]').hasMatch(password)) {
    return 'Password must include at least one number.';
  }
  // Special character (not letter or digit)
  if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
    return 'Password must include at least one special character (e.g. @ # !).';
  }
  return null;
}
