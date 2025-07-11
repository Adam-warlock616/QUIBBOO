
import 'package:flutter/material.dart';

bool isPasswordValid(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  return value.length >= 8;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  return null;
}

String? confirmPasswordValidator(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}

Color getHeaderTextColor(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return isDarkMode ? Colors.blue.shade200 : Colors.blue.shade800;
}

Color getBodyTextColor(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
}
