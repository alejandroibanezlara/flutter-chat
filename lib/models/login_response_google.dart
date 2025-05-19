// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario.dart';

// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);


LoginGoogleResponse loginGoogleResponseFromJson(String str) => LoginGoogleResponse.fromJson(json.decode(str));

String loginGoogleResponseToJson(LoginGoogleResponse data) => json.encode(data.toJson());

class LoginGoogleResponse {
    bool ok;
    Usuario googleUser;

    LoginGoogleResponse({
        required this.ok,
        required this.googleUser,
    });

    factory LoginGoogleResponse.fromJson(Map<String, dynamic> json) => LoginGoogleResponse(
        ok: json["ok"],
        googleUser: Usuario.fromJson(json["googleUser"]),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "googleUser": googleUser.toJson(),
    };
}