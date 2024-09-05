import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  

  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  Future<dynamic> get(String endpoint) async {
    var response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}