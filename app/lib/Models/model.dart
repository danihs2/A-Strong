import 'dart:convert';

class Usuario{
  num? id;
  String? username;
  String? email;

  num? metaPeso;
  num? metaPorcentajeGrasa;
  num? metaCaloriasDiarias;

  Usuario({
    this.id,
    this.username,
    this.email,
    this.metaPeso,
    this.metaPorcentajeGrasa,
    this.metaCaloriasDiarias
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      metaPeso: json['metaPeso'],
      metaPorcentajeGrasa: json['metaPorcentajeGrasa'],
      metaCaloriasDiarias: json['metaCaloriasDiarias']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'metaPeso': metaPeso,
      'metaPorcentajeGrasa': metaPorcentajeGrasa,
      'metaCaloriasDiarias': metaCaloriasDiarias
    };
  }

  // Convert json to base64
  String toBase64() {
    return json.encode(this);
  }
  // Convert Usuario to base64
  String toBase64Usuario() {
    return json.encode(this);
  }
  // Convert base64 to json
  static Usuario fromBase64(String base64) {
    return Usuario.fromJson(json.decode(base64));
  }
  // Convert base64 to Usuario
  static Usuario fromBase64ToUsuario(String base64) {
    return Usuario.fromJson(json.decode(base64));
  }
} 

class DataActual{
  num? peso;
  num? altura;
  num? cintura;
  num? cuello;
  num? cadera;
  num? sexo;

  DataActual({
    this.peso,
    this.altura,
    this.cintura,
    this.cuello,
    this.cadera,
    this.sexo
  });

  factory DataActual.fromJson(Map<String, dynamic> json) {
    return DataActual(
      peso: json['peso'],
      altura: json['altura'],
      cintura: json['cintura'],
      cuello: json['cuello'],
      cadera: json['cadera'],
      sexo: json['sexo']
    );
  }
}

class ProgresoDiario{
  String? fecha;
  num? peso;
  num? porcentajeGrasa;
  num? caloriasConsumidas;

  ProgresoDiario({
    this.fecha,
    this.peso,
    this.porcentajeGrasa,
    this.caloriasConsumidas
  });

  factory ProgresoDiario.fromJson(Map<String, dynamic> json) {
    return ProgresoDiario(
      fecha: json['fecha'],
      peso: json['peso'],
      porcentajeGrasa: json['porcentajeGrasa'],
      caloriasConsumidas: json['caloriasConsumidas']
    );
  }
}

class Logica{

}