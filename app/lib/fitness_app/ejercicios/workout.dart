import 'dart:convert';

import 'package:a_strong/Models/workouts.dart';
import 'package:a_strong/fitness_app/ejercicios/Widgets/template_selector.dart';
import 'package:a_strong/fitness_app/ejercicios/Widgets/work_selector.dart';
import 'package:flutter/material.dart';
import 'package:a_strong/Services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Workout extends StatefulWidget {
  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String apiResponse = '';
  List <GrupoMuscular> grupoMuscular = [];
  List<Ejercicio> ejercicios = [];
  List<Template> templates = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // Controler de input nombre del template
    TextEditingController _textController = TextEditingController();

    return Scaffold(
      // Your widget's UI goes here
      appBar: AppBar(
        title: const Text('Workout'),
      ),
      body: Column(
        children: [
          // Input nombre del template
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre del template',
            ),
          ),
          
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35, // Ocupa el 60% de la altura de la pantalla
            child: WorkSelector(
              ejercicios: ejercicios,
              onSelectionChanged: (List<Ejercicio> ejercicios) {
                setState(() {
                  this.ejercicios = ejercicios;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Your code to save the data
              //print('Ejercicios seleccionados: ${ejercicios.where((element) => element.seleccionado).map((e) => e.nombre).toList()}');
              // Esos ejercicios guardarlos en un objeto y ponerlo en un objeto de tipo template
              List<Ejercicio> ejerciciosSeleccionados = ejercicios.where((element) => element.seleccionado).toList();
              Template template = Template(
                ejercicios: ejerciciosSeleccionados,
                nombre: _textController.text
              );
              // Guardar el template en la base de datos
              print("Template: ${template.toJson()}");
              // return;
              final response = await ApiService.instance.postDataToEndpoint('templates/', template.toJson());
              print('Response: ${response}');
              // Navegar a la pantalla de templates
              Navigator.pop(context);
            },
            child: const Text('Guardar Template'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navegar a la pantalla de templates
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemplateSelector()
                )
              );
            },
            child: const Text('Ver Templates'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navegar a la pantalla de templates
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
        ],
      )
    );
  }

  getData() async {
    // Your code to fetch data from API
    // de la api_service.dart
    try{
      final ejerciciosResponse = await ApiService.instance.getDataFromEndpoint('ejercicios');
      final grupoMuscularResponse = await ApiService.instance.getDataFromEndpoint('grupos-musculares');
      final templatesResponse = await ApiService.instance.getDataFromEndpoint('templates');

      setState(() {
        ejercicios = (ejerciciosResponse as List).map((item) => Ejercicio.fromJson(item)).toList();
        grupoMuscular = (grupoMuscularResponse as List).map((item) => GrupoMuscular.fromJson(item)).toList();
        templates = (templatesResponse as List).map((item) => Template.fromJson(item)).toList();
      });
      //print("templatesResponse: ${templatesResponse}");
    }catch(e){
      print('Error ${e}');
    }
  }
}