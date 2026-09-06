String normalizeLoginId(String raw) {
  final trimmed = raw.trim().toLowerCase();
  if (trimmed.contains('@')) {
    return trimmed;
  }
  return trimmed.replaceAll(RegExp(r'\D'), '');
}

bool isValidLoginId(String raw) {
  final loginId = normalizeLoginId(raw);
  if (loginId.contains('@')) {
    return loginId.contains('.') && loginId.length >= 5;
  }
  return RegExp(r'^\d{10,15}$').hasMatch(loginId);
}
