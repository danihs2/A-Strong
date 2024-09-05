import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl = 'http://172.28.153.131:8000/api';
  

  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  Future<dynamic> getDataFromEndpoint(String endpoint) async {
    var response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> postDataToEndpoint(String endpoint, dynamic data) async {
  var response = await http.post(
    Uri.parse('$baseUrl/$endpoint'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: convert.jsonEncode(data),
  );
  
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 201) {
    return convert.jsonDecode(response.body);
  } else {
    throw Exception('Failed to post data: ${response.body}');
  }
}
}