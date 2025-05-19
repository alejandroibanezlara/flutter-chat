import 'package:chat/global/environment.dart';
import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/google2_signin_service.dart';
import 'package:chat/services/google_signin_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/btn_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:chat/widgets/terms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/auth_service.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(titulo: 'Inicio'),
                _Form(),
                Labels(ruta: 'register', texto1: '¿No tienes cuenta?',  texto2: 'Crea una ahora!'),
                Terms(),
              ],
            ),
          ),
        ),
      ),

    );
  }
}





class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>( context );
    GoogleSignInService2 googleService = GoogleSignInService2();

    return Container(

      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Password',
            keyboardType: TextInputType.text,
            textController: passCtrl,
            isPassword: true,
          ),
          BtnAzul(
            texto: 'Ingresar',
            color: Colors.blue,
            
            onPress: authService.autenticando ? (){} : () async {
              

              FocusScope.of(context).unfocus();
              final loginOK = await authService.login(emailCtrl.text, passCtrl.text);

              if(loginOK){
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'home');
              }else{
                mostrarAlerta(context, 'Login KO', 'Revisar credenciales');
              }


            } ,
          ),

          BtnAzul(
            texto: 'GOOGLE',
            color: Colors.blue,
            
            onPress: () async{
              final loginOK2 = await googleService.signInWithGoogle2();


              if(loginOK2 == true){
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else{
                mostrarAlerta(context, 'Login KO', 'Revisar credenciales');
              }

            } ,
          ),
        ],
      ),
    );
  }
}






