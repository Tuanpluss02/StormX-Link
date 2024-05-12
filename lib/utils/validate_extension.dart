String? usernameValidator(String? value) {
  final regex =
      RegExp(r'^(?!.*[-_.]{2})[A-Za-z0-9]+[A-Za-z0-9_.\-]*[A-Za-z0-9]$');
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  if (!regex.hasMatch(value.trim())) {
    return 'Username must be 4-20 characters long and can only contain letters, numbers, underscores, periods and hyphens.';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

String? longUrlValidator(String? value) {
  final regex = RegExp(
      r'(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})?');
  if (value == null || value.isEmpty) {
    return 'Long URL is required';
  }
  if (!regex.hasMatch(value.trim())) {
    return 'Please enter a valid URL';
  }
  return null;
}

String? urlCodeValidator(String? value) {
  final regex =
      RegExp(r'^(?!.*[-_.]{2})[A-Za-z0-9]+[A-Za-z0-9_.\-]*[A-Za-z0-9]$');
  if (value == null || value.isEmpty) {
    return null;
  } else if (!regex.hasMatch(value.trim())) {
    return 'URL Code can only contain letters, numbers, underscores and hyphens.';
  }
  return null;
}
