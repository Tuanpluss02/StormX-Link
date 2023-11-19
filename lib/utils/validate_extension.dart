import 'package:form_validator/form_validator.dart';

extension PasswordVaidate on ValidationBuilder {
  password() => add((value) {
        final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (!regex.hasMatch(value)) {
          return 'Password must be 8 characters long and contain at least one uppercase letter, one lowercase letter and one number.';
        }
        return null;
      });
}

extension UsernameVaidate on ValidationBuilder {
  username() => add((value) {
        final regex =
            RegExp(r'^(?!.*[-_.]{2})[A-Za-z0-9]+[A-Za-z0-9_.\-]*[A-Za-z0-9]$');
        if (value == null || value.isEmpty) {
          return 'Username is required';
        }
        if (!regex.hasMatch(value)) {
          return 'Username must be 4-20 characters long and can only contain letters, numbers, underscores, periods and hyphens.';
        }
        return null;
      });
}
