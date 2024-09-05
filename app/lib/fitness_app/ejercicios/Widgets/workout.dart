import 'package:a_strong/Models/workouts.dart';
import 'package:a_strong/Services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async'; // Importa la biblioteca dart:async

class WorkoutWidget extends StatefulWidget {
  final num id;

  const WorkoutWidget({super.key, required this.id});

  @override
  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  bool isRunning = false;
  DateTime? startTime;
  DateTime? endTime;
  String tiempoTranscurrido = '';
  Timer? timer; // Agrega una variable para el Timer

  Template template = Template();
  bool isLoading = true;

  Historial historial = Historial();
  List<EjercicioHistorial> ejercicioHistorial = [];

  void startExercise() {
    setState(() {
      isRunning = true;
      startTime = DateTime.now();
      tiempoTranscurrido = '0';
    });

    // Inicia el Timer que actualiza el tiempo transcurrido cada segundo
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (isRunning) {
        setState(() {
          tiempoTranscurrido = DateTime.now().difference(startTime!).inSeconds.toString();
        });
      } else {
        t.cancel(); // Cancela el Timer si el ejercicio se detiene
      }
    });

    Fluttertoast.showToast(msg: 'Iniciando ejercicio');
  }

  void stopExercise() {
    setState(() {
      isRunning = false;
      endTime = DateTime.now();
      // Poner el tiempo transcurrido en el objeto historial
      historial.tiempo = endTime!.difference(startTime!).inSeconds;
      // Juntar el historial con los ejercicios
      // para enviarlo al servidor, Sera un json donde venga 'historial' => objeto Historial y 'ejercicioHistorial' => [{idEjercicio, peso, repeticiones}]
      final body = {
        'historial': historial.toJson(),
        'ejercicioHistorial': ejercicioHistorial.map((e) => e.toJson()).toList(),
      };
      print('Enviando datos al servidor: $body');
      // return;
      ApiService.instance.postDataToEndpoint('historial/', body);
    });

    // Asegúrate de cancelar el Timer cuando se detiene el ejercicio
    timer?.cancel();

    final duration = endTime!.difference(startTime!);
    Fluttertoast.showToast(msg: 'Ejercicio finalizado. Tiempo transcurrido: ${duration.inSeconds} segundos');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
      ),
      body: isLoading ? const Column() : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Template: ${widget.id} | ${template.nombre}'),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: template.ejercicios!.map((ejercicio) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${ejercicio.nombre}',
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Ingrese ${ejercicio.unidad}',
                              ),
                              onChanged: (value) {
                                // Actualiza la cantidad de peso en el historial
                                final index = ejercicioHistorial.indexWhere((element) => element.idEjercicio == ejercicio.id);
                                if (index != -1) {
                                  ejercicioHistorial[index].peso = int.tryParse(value) ?? 0;
                                }
                                setState(() {
                                  // Actualiza el estado para que se refleje en la UI
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Repeticiones',
                              ),
                              onChanged: (value) {
                                // Actualiza la cantidad de repeticiones en el historial
                                final index = ejercicioHistorial.indexWhere((element) => element.idEjercicio == ejercicio.id);
                                if (index != -1) {
                                  ejercicioHistorial[index].repeticiones = int.tryParse(value) ?? 0;
                                }
                                setState(() {
                                  // Actualiza el estado para que se refleje en la UI
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Tiempo transcurrido: ${isRunning ? tiempoTranscurrido : 0} segundos'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRunning ? stopExercise : startExercise,
              child: Text(isRunning ? 'Terminar ejercicio' : 'Iniciar ejercicio'),
            ),
          ],
        ),
      ),
    );
  }

  getData() async {
    // Get data from API
    print("object");
    final templateResponse = await ApiService.instance.getDataFromEndpoint('templates/${widget.id}/');
    if (templateResponse != null) {
      template = Template.fromJson(templateResponse);
      // Inicializa el historial con el template seleccionado
      historial.idTemplate = template.id;
      // Fecha
      historial.fecha = DateTime.now().toString();
      // Inicializa la lista de ejercicios con el template seleccionado
      // y establece el tiempo en 0
      ejercicioHistorial = template.ejercicios!.map((e) => EjercicioHistorial(idEjercicio: e.id)).toList(); 
    }
    isLoading = false;
    setState(() {});
  }
}
