import 'package:a_strong/Services/api_service.dart';
import 'package:flutter/material.dart';

class EjercicioDetalle extends StatefulWidget {
  final int idRecibidoDelWidget;

  const EjercicioDetalle({super.key, required this.idRecibidoDelWidget});

  @override
  _EjercicioDetalleState createState() => _EjercicioDetalleState();
}

class _EjercicioDetalleState extends State<EjercicioDetalle> {
  dynamic _ejercicioFuture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final response = await ApiService.instance.getDataFromEndpoint('ejercicios/${widget.idRecibidoDelWidget}');
    _ejercicioFuture = response;
    setState(() {
      _ejercicioFuture = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio'),
      ),
      body: isLoading? const Column() : ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Image.asset('assets/ejercicios/${_ejercicioFuture['noImagen']}.jpeg'),
                  SizedBox(height: 16.0),
                  Text(_ejercicioFuture['descripcion']),
                  SizedBox(height: 16.0),
                  Text(_ejercicioFuture['instrucciones']),
                ],
              ),
    );
  }
}