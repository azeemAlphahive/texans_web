import 'dart:convert';

/// Extracts a short, user-facing string from common JSON API bodies.
///
/// Handles `message`, `error` (string or list), Laravel-style `errors`, and
/// `data.message` so snackbars never show raw JSON.
String? messageFromApiBody(String body) {
  if (body.trim().isEmpty) return null;
  try {
    final parsed = jsonDecode(body);
    return _messageFromJson(parsed);
  } catch (_) {
    return null;
  }
}

/// Same as [messageFromApiBody], but never returns a raw JSON-looking string.
String userFacingApiMessage(String body, String fallback) {
  final parsed = messageFromApiBody(body);
  if (parsed != null && parsed.trim().isNotEmpty) return parsed.trim();
  final trimmed = body.trim();
  if (trimmed.isEmpty) return fallback;
  if (trimmed.startsWith('{') && trimmed.endsWith('}')) return fallback;
  return trimmed;
}

bool _isGenericServerMessage(String s) {
  switch (s.toLowerCase()) {
    case 'invalid format':
    case 'bad request':
    case 'error':
    case 'the given data was invalid.':
      return true;
    default:
      return false;
  }
}

String? _firstValidationError(Map<String, dynamic> map) {
  final errors = map['errors'];
  if (errors is! Map) return null;
  for (final v in errors.values) {
    if (v is List && v.isNotEmpty) {
      final first = v.first;
      if (first is String && first.trim().isNotEmpty) return first.trim();
      return first?.toString();
    }
    if (v is String && v.isNotEmpty) return v;
  }
  return null;
}

String? _messageFromJson(dynamic parsed) {
  if (parsed is! Map) return null;
  final map = Map<String, dynamic>.from(parsed);

  final validation = _firstValidationError(map);
  final message = map['message'];
  final msgStr = message is String ? message.trim() : '';

  if (validation != null &&
      (msgStr.isEmpty || _isGenericServerMessage(msgStr))) {
    return validation;
  }
  if (msgStr.isNotEmpty) return msgStr;
  if (validation != null) return validation;

  final error = map['error'];
  if (error is String && error.trim().isNotEmpty) return error.trim();
  if (error is List && error.isNotEmpty) {
    final first = error.first;
    if (first is String) return first;
    return first?.toString();
  }

  final data = map['data'];
  if (data is Map) {
    final dm = data['message'];
    if (dm is String && dm.trim().isNotEmpty) return dm.trim();
  }

  return null;
}
