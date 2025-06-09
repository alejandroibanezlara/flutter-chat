// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    bool? online;
    String? nombre;
    String? email;
    // String? picture;
    // String? name;
    String uid;

    Usuario({
        this.online,
        this.nombre,
        this.email,
        required this.uid, 
        // required picture, 
        // required name,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"] ?? false,
        nombre: json["nombre"] as String?,
        email: json["email"] as String?,
        // picture: json["picture"],
        // name: json["name"],
        uid: (json["uid"] ?? json["_id"])?.toString() ?? '',
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


// class Usuario {
//   final String uid;
//   final String? nombre;
//   final String? email;
//   final bool? online;

//   Usuario({
//     required this.uid,
//     this.nombre,
//     this.email,
//     this.online,
//   });

//   factory Usuario.fromJson(Map<String, dynamic> json) {
//     return Usuario(
//       uid: json['_id']?.toString() ?? '',
//       nombre: json['nombre'] as String?,
//       email: json['email'] as String?,
//       online: json['online'] as bool? ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         '_id': uid,
//         'nombre': nombre,
//         'email': email,
//         'online': online,
//       };
// }