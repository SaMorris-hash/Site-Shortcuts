Uri? parseSiteUrl(String value) {
  final input = value.trim();

  if (input.isEmpty || RegExp(r'\s').hasMatch(input)) {
    return null;
  }

  final address = input.contains('://') ? input : 'https://$input';
  final uri = Uri.tryParse(address);

  if (uri == null ||
      (uri.scheme != 'http' && uri.scheme != 'https') ||
      uri.host.isEmpty ||
      !uri.host.contains('.')) {
    return null;
  }

  return uri;
}