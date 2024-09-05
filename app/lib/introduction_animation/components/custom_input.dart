import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final Function(dynamic) callback;
  final IconData icon;
  final dynamic initialValue;
  final bool isRequired;
  final TextInputType keyboardType;

  const CustomInput({
    super.key,
    required this.label,
    required this.callback,
    required this.icon,
    required this.initialValue,
    this.isRequired = true,
    this.keyboardType = TextInputType.text,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Si initial value no es null, se asigna al controlador
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Colors.black54),
          textAlign: TextAlign.start,
        ),
        Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16),
          child: TextFormField(
            keyboardType: widget.keyboardType,
            validator: (value) {
              if (widget.isRequired && value!.isEmpty) {
                return "${widget.label} es requerido";
              }
              return null;
            },
            onSaved: (email) {
              widget.callback(email);
            },
            decoration: InputDecoration(
                prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(widget.icon),
              )),
            ),
        ),
      ],
    );
  }
}