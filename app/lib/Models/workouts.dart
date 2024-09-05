import 'dart:convert';

class GrupoMuscular{
  num? id;
  String? nombre;
  String? descripcion;
  String? noImagen;

  GrupoMuscular({
    this.id,
    this.nombre,
    this.descripcion,
    this.noImagen
  });

  factory GrupoMuscular.fromJson(Map<String, dynamic> json) {
    return GrupoMuscular(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion']??'',
      // Si es numero, se convierte a string
      noImagen: json['noImagen'] is int ? json['noImagen'].toString() : json['noImagen']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': noImagen
    };
  }

  // Convert json to base64
  String toBase64() {
    return json.encode(this);
  }
  // Convert GrupoMuscular to base64
  String toBase64GrupoMuscular() {
    return json.encode(this);
  }
  // Convert base64 to json
  static GrupoMuscular fromBase64(String base64) {
    return GrupoMuscular.fromJson(json.decode(base64));
  }
  // Convert base64 to GrupoMuscular
  static GrupoMuscular fromBase64ToGrupoMuscular(String base64) {
    return GrupoMuscular.fromJson(json.decode(base64));
  }
}

class Ejercicio{
  num? id;
  num? idGrupoMuscular;
  String? nombre;
  String? descripcion;
  String? instrucciones;
  String? unidad;
  String? noImagen;

  bool seleccionado = false;

  GrupoMuscular? grupoMuscular;

  Ejercicio({
    this.id,
    this.idGrupoMuscular,
    this.nombre,
    this.descripcion,
    this.instrucciones,
    this.unidad,
    this.noImagen
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      id: json['id'],
      idGrupoMuscular: json['idGrupoMuscular'],
      nombre: json['nombre'],
      descripcion: json['descripcion']??'',
      instrucciones: json['instrucciones']??'',
      unidad: json['unidad']??'',
      noImagen: json['noImagen'] is int ? json['noImagen'].toString() : json['noImagen']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      //'idGrupoMuscular': idGrupoMuscular,
      'nombre': nombre,
      'descripcion': descripcion,
      'instrucciones': instrucciones,
      'unidad': unidad,
      'imagen': noImagen,
    };
  }

  // Convert json to base64
  String toBase64() {
    return json.encode(this);
  }
  // Convert Ejercicio to base64
  String toBase64Ejercicio() {
    return json.encode(this);
  }
  // Convert base64 to json
  static Ejercicio fromBase64(String base64) {
    return Ejercicio.fromJson(json.decode(base64));
  }
  // Convert base64 to Ejercicio
  static Ejercicio fromBase64ToEjercicio(String base64) {
    return Ejercicio.fromJson(json.decode(base64));
  }
}

class Template {
  num? id;
  List<Ejercicio>? ejercicios;
  String? nombre;

  Template({
    this.id,
    this.ejercicios,
    this.nombre,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'],
      nombre: json['nombre'],
      // Convierte la lista de ejercicios JSON a una lista de objetos Ejercicio
      ejercicios: (json['ejercicios'] as List<dynamic>)
          .map((item) => Ejercicio.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'nombre': nombre,
      //'ejercicios': ejercicios?.map((e) => e.toJson()).toList(),
      'ejercicio_ids': ejercicios?.map((e) => e.id).toList(),
    };
  }
  
  Map<String, dynamic> toJsonComplete() {
    return {
      //'id': id,
      'nombre': nombre,
      'ejercicios': ejercicios?.map((e) => e.toJson()).toList(),
      'ejercicio_ids': ejercicios?.map((e) => e.id).toList(),
    };
  }
}

class Historial {
  num? id;
  num? idTemplate;
  String? fecha;
  // Duration tiempo;
  num? tiempo;

  Historial({
    this.id,
    this.idTemplate,
    this.fecha,
    this.tiempo,
  });

  factory Historial.fromJson(Map<String, dynamic> json) {
    return Historial(
      id: json['id'],
      idTemplate: json['idTemplate'],
      fecha: json['fecha'],
      tiempo: json['tiempo_total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTemplate': idTemplate,
      'fecha': fecha,
      'tiempo_total': tiempo,
    };
  }
}

class EjercicioHistorial {
  num? id;
  num? idHistorial;
  num? idEjercicio;
  num? peso;
  num? repeticiones;

  EjercicioHistorial({
    this.id,
    this.idHistorial,
    this.idEjercicio,
    this.peso, // Valor de la unidad de medida
    this.repeticiones,
  });

  factory EjercicioHistorial.fromJson(Map<String, dynamic> json) {
    return EjercicioHistorial(
      id: json['id'],
      idHistorial: json['idHistorial'],
      idEjercicio: json['idEjercicio'],
      peso: json['peso'],
      repeticiones: json['repeticiones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idHistorial': idHistorial,
      'idEjercicio': idEjercicio,
      'peso': peso,
      'repeticiones': repeticiones,
    };
  }
}
