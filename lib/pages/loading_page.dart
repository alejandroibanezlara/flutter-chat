import 'package:chat/pages/main_menu/home_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/main_menu/_old/usuarios_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context), 
        builder: (context, snapshot){
          return Center(
            child: Text('Espere...'),
          );
        }),
    );
  }


  

  Future checkLoginState(BuildContext context) async{
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIt();

    if(autenticado){
      // Navigator.pushReplacementNamed(context, 'usuarios');
      socketService.connect();
      Navigator.pushReplacement(context, 
        PageRouteBuilder(
          // pageBuilder: ( _, __, ___ ) => UsuariosPage(),
          pageBuilder: ( _, __, ___ ) => HomePage(),
          transitionDuration: Duration(milliseconds: 0)
          ));
    }else{
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
          ));
    }
  }
}


