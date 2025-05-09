import 'dart:convert';

class Noticia {
  final String id;
  final String titular;
  final String imagen;
  final String categoria;
  final String descripcion;
  final String fecha;
  final String estado;

  Noticia({
    required this.id,
    required this.titular,
    required this.imagen,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.estado,
  });

  Noticia copyWith({
    String? id,
    String? titular,
    String? imagen,
    String? categoria,
    String? descripcion,
    String? fecha,
    String? estado,
  }) => Noticia(
    id: id ?? this.id,
    titular: titular ?? this.titular,
    imagen: imagen ?? this.imagen,
    categoria: categoria ?? this.categoria,
    descripcion: descripcion ?? this.descripcion,
    fecha: fecha ?? this.fecha,
    estado: estado ?? this.estado,
  );

  factory Noticia.fromRawJson(String str) => Noticia.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Noticia.fromJson(Map<String, dynamic> json) => Noticia(
    id: json["id"],
    titular: json["titular"],
    imagen: json["imagen"],
    categoria: json["categoria"],
    descripcion: json["descripcion"],
    fecha: json["fecha"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titular": titular,
    "imagen": imagen,
    "categoria": categoria,
    "descripcion": descripcion,
    "fecha": fecha,
    "estado": estado,
  };
}
