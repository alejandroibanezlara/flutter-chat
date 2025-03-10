import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'Alejandro', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Manuel', email: 'test2@test.com', online: true),
    Usuario(uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: false)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi nombre'),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){}, 
          icon: Icon(Icons.exit_to_app)
          ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
          )
        ],

      ),
      body:SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400]!,
        ),
        child: listViewUsuarios(),

        )
    );
  }

  ListView listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: ( _, i ) => _usuarioListTile(usuarios[i]),
      separatorBuilder: ( _, i) => Divider(),
      itemCount: usuarios.length,
    );
  }




  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: 
          Text((usuario.nombre.isNotEmpty) 
            ? usuario.nombre.substring(0,2)
            : ''),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );

  }


  _cargarUsuarios() async{
        // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
  }
}
