// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class EncoderService {
  static String base46_encode(Object? v) {
    if (v == null || (v is String && v.isEmpty)) return "";

    List<int> value = json.encode(v).codeUnits;
    final stringChars = String.fromCharCodes(value);
    final bytes = utf8.encode(stringChars);
    return base64Encode(bytes);
  }

  static Object? base46_decode(String? v) {
    if (v == null || v.isEmpty) return null;

    final bytes = base64Decode(v);
    final stringChars = String.fromCharCodes(bytes);
    final value = utf8.decode(stringChars.codeUnits);
    return json.decode(value);
  }

  static String base46_encode_uri(Uri? v) {
    if (v == null) return "";
    String value = v.toString();
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    return stringToBase64Url.encode(value);
  }

  static Uri? base46_decode_uri(String? v) {
    if (v == null || v.isEmpty) return null;
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    return Uri.tryParse(stringToBase64Url.decode(v));
  }
}



/// object -> codeUnits -> stringChars -> bytes -> base64Encode
/// base64Decode -> bytes -> stringChars -> codeUnits -> object