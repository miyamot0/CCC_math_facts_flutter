import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> parseJsonFromAssets(String path) async {
  return rootBundle.loadString(path).then((json) => jsonDecode(json));
}