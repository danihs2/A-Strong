import 'package:a_strong/Models/workouts.dart';
import 'package:a_strong/Services/api_service.dart';
import 'package:a_strong/fitness_app/ejercicios/Widgets/workout.dart';
import 'package:flutter/material.dart';

class TemplateSelector extends StatefulWidget {
  const TemplateSelector({Key? key}) : super(key: key);

  @override
  State<TemplateSelector> createState() => _TemplateSelectorState();
}

class _TemplateSelectorState extends State<TemplateSelector> {
  List<Template> templates = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un template'),
      ),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(template.nombre ?? 'Template'),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.fitness_center), // Icono de ejercicios o workout
                      Text(' ${template.ejercicios?.length ?? 0} ejercicios'), // Número de ejercicios
                      const SizedBox(width: 8),
                      const Icon(Icons.local_drink), // Icono de copas
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutWidget(id: template.id! as num),
                      ),
                    );
                  },
                ),
                // Imprimier los ejercicios
                if (template.ejercicios != null)
                  for (final ejercicio in template.ejercicios!)
                    ListTile(
                      title: Text(ejercicio.nombre ?? 'Ejercicio'),
                      subtitle: Text(ejercicio.descripcion ?? 'Descripción', style: const TextStyle(fontSize: 10,),),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  getData() async {
    // Get data from API
    final templateResponse = await ApiService.instance.getDataFromEndpoint('templates');
    if (templateResponse != null) {
      templates = templateResponse.map<Template>((e) => Template.fromJson(e)).toList();
    }
    setState(() {});
  }
}