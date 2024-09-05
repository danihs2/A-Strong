import 'package:a_strong/Services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistorialWidget extends StatefulWidget {
  @override
  _HistorialWidgetState createState() => _HistorialWidgetState();
}

class _HistorialWidgetState extends State<HistorialWidget> {
  List<dynamic> historialData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final templateResponse = await ApiService.instance.getDataFromEndpoint('historial/');
      
        // print('Historial${templateResponse}');
      setState(() {
        historialData = templateResponse;
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      body: isLoading ? Container() : ListView.builder(
        itemCount: historialData.length,
        itemBuilder: (context, index) {
          final historial = historialData[index]['historial'];
          final ejercicios = historialData[index]['ejercicios_historial'];
            
          return Card(
            child: Column(
              children: [
                Text('ID: ${historial['id']}'),
                Text('Template: ${historial['template']}'),
                Text('Fecha: ${historial['fecha']}'),
                Text('Tiempo Total: ${historial['tiempo_total']}'),
                SizedBox(height: 10),
                Text('Ejercicios:'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ejercicios.length,
                  itemBuilder: (context, index) {
                    final ejercicio = ejercicios[index];
                    return ListTile(
                      title: Text('Nombre: ${ejercicio['nombreEjercicio']}'),
                      subtitle: Text('Peso: ${ejercicio['peso']}'),
                      trailing: Text('Repeticiones: ${ejercicio['repeticiones']}'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}