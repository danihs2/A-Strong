import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Workout extends StatefulWidget {
  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String apiResponse = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your widget's UI goes here
      appBar: AppBar(
        title: Text('Workout'),
      ),
      body: Column(

      )
    );
  }
}

class ApiService {
  static Future<http.Response> getData() async {
    return await http.get(Uri.parse('https://api.example.com/data'));
  }
}