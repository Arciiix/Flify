/// Returns true if valid
bool isPortValid(String? value) {
  return (value != null &&
      int.tryParse(value) != null &&
      int.parse(value) >= 1 &&
      int.parse(value) <= 65535);
}

/// Returns true if valid
bool isIPv4Valid(String? value) {
  try {
    Uri.parseIPv4Address(value ?? "");
    return true;
  } catch (e) {
    return false;
  }
}
