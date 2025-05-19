

import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/login_response_google.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService2{

  Usuario? usuario;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final _storage = new FlutterSecureStorage();


    Future signInWithGoogle2() async {

      try{

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final googleKey = await googleUser?.authentication;

        print(googleKey?.idToken);



        if(googleUser !=null){


          print(12345678888888888);


              final uri = Uri.parse('${ Environment.apiUrl }/login/google');


              final resp = await http.post(uri, 
                body:  {
                  'token': googleKey?.idToken
                }
              );
              print(googleKey?.idToken);
              print(resp.body);
              print(resp.statusCode);
              _guardarToken(googleKey!.idToken!);

              final loginRessponse = loginGoogleResponseFromJson(resp.body);

              print(loginRessponse);

              usuario = loginRessponse.googleUser;
              // usuario = Usuario(
              //   online: true, 
              //   nombre: resp.body.googleUser?.name!, 
              //   email: resp.body?.email, 
              //   uid:resp.body?.uid, 
              //   picture: resp.body?.picture, 
              //   name: resp.body?.name);
              
              
              print(usuario);

              // if(resp.statusCode == 200){
              //   final loginRessponse = loginResponseFromJson(resp.body);
              //   usuario = loginRessponse.usuario;
              //   _guardarToken(loginRessponse.token);
              //   return true;
              // }else{
              //   return false;
              // }

        }else{
          throw Exception("Google Sign-In failed or cancelled");
        }

        // return true;

      }catch(e){
        print('Error en google sign in');
        print(e);
          return false;
        // return false;
        // throw Exception("Error during Google Sign-In");
      }
    
    }

    Future signOut() async{
      try{
        await _googleSignIn.signOut(); 
        await _auth.signOut(); 
      }catch (e){
        print('Error en google sign out');
      }
      
    }


  Future _guardarToken( String token) async {
    return await _storage.write(key: 'token', value: token);
  }

}