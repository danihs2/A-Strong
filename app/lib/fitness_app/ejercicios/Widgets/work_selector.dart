import 'package:a_strong/Models/workouts.dart';
import 'package:flutter/material.dart';

class WorkSelector extends StatefulWidget {
  final List<Ejercicio> ejercicios;
  final Function(List<Ejercicio>) onSelectionChanged;

  WorkSelector({required this.ejercicios, required this.onSelectionChanged});

  @override
  _WorkSelectorState createState() => _WorkSelectorState();
}

class _WorkSelectorState extends State<WorkSelector> {
  void _toggleSelection(int index) {
    setState(() {
      widget.ejercicios[index].seleccionado = !widget.ejercicios[index].seleccionado;
      widget.onSelectionChanged(widget.ejercicios);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.ejercicios.length,
      itemBuilder: (context, index) {
        final ejercicio = widget.ejercicios[index];
        return ListTile(
          leading: Image.asset(
            'assets/ejercicios/${ejercicio.noImagen}.jpeg',
            width: 50, // Ajusta el tamaño según sea necesario
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(ejercicio.nombre ?? 'Ejercicio'),
          trailing: Checkbox(
            value: ejercicio.seleccionado,
            onChanged: (value) => _toggleSelection(index),
          ),
        );
      },
    );
  }

}