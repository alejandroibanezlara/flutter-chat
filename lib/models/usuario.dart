// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    bool online;
    String nombre;
    String email;
    // String? picture;
    // String? name;
    String uid;

    Usuario({
        required this.online,
        required this.nombre,
        required this.email,
        required this.uid, 
        // required picture, 
        // required name,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        // picture: json["picture"],
        // name: json["name"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        // "picture": picture,
        // "name": name,
        "uid": uid,
    };
}
