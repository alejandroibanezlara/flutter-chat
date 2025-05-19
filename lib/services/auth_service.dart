import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';

import 'package:chat/models/login_response.dart';
import 'package:chat/models/usuario.dart';


import 'package:google_sign_in/google_sign_in.dart';


class AuthService with ChangeNotifier {

  Usuario? usuario;
  bool _autenticando = false;
  
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }

  //Getter del token de forma estatica
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key:'token');
    if(token!=null){
      return token;
    }else{
      return '';
    }
      
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key:'token');

  }



  Future<bool> login( String email, String password ) async {
 
    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Environment.apiUrl }/login');


    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    autenticando = false;


    if(resp.statusCode == 200){
      final loginRessponse = loginResponseFromJson(resp.body);
      usuario = loginRessponse.usuario;
      _guardarToken(loginRessponse.token);
      return true;
    }else{
      return false;
    }

  }


  Future register(String nombre, String email, String password) async {
   
   autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Environment.apiUrl }/login/new');

    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    autenticando = false;


    if(resp.statusCode == 200){
      final loginRessponse = loginResponseFromJson(resp.body);
      usuario = loginRessponse.usuario;
      _guardarToken(loginRessponse.token);
      return true;
    }else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIt() async{

    final token = await _storage.read(key: 'token');

    final uri = Uri.parse('${ Environment.apiUrl }/login/renew');

    final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token!
      }
    );


    if(resp.statusCode == 200){
      final loginRessponse = loginResponseFromJson(resp.body);
      usuario = loginRessponse.usuario;
      _guardarToken(loginRessponse.token);
      return true;
    }else{
      _logOut();
      return false;
    }
    
  }

  Future _guardarToken( String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logOut() async {
    await _storage.delete(key: 'token');
  }

}