class RegexValidate {
  bool isValidShortName(String shortName) {
    final RegExp shortNameRegex = RegExp(r'^[a-zA-Z0-9]+-?[a-zA-Z0-9]+$');
    return shortNameRegex.hasMatch(shortName);
  }

  bool isValidLongUrl(String longUrl) {
    final RegExp longUrlRegex = RegExp(
        r'^(http|https):\/\/[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$');
    return longUrlRegex.hasMatch(longUrl);
  }
}
