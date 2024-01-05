String? usernameValidator(String? value) {
  final regex =
      RegExp(r'^(?!.*[-_.]{2})[A-Za-z0-9]+[A-Za-z0-9_.\-]*[A-Za-z0-9]$');
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  if (!regex.hasMatch(value)) {
    return 'Username must be 4-20 characters long and can only contain letters, numbers, underscores, periods and hyphens.';
  }
  return null;
}

String? passwordValidator(String? value) {
  final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (!regex.hasMatch(value)) {
    return 'Password must be 8 characters long and contain at least one uppercase letter, one lowercase letter and one number.';
  }
  return null;
}

String? longUrlValidator(String? value) {
  final regex = RegExp(
      r'(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})?');
  if (value == null || value.isEmpty) {
    return 'Long URL is required';
  }
  if (!regex.hasMatch(value)) {
    return 'Please enter a valid URL';
  }
  return null;
}

String? urlCodeValidator(String? value) {
  final regex =
      RegExp(r'^(?!.*[-_.]{2})[A-Za-z0-9]+[A-Za-z0-9_.\-]*[A-Za-z0-9]$');
  if (value == null || value.isEmpty) {
    return null;
  } else if (!regex.hasMatch(value)) {
    return 'URL Code can only contain letters, numbers, underscores and hyphens.';
  }
  return null;
}
