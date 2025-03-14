import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;



  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService   = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', (data) => null);

    _cargarHistorial( chatService.usuarioPara.uid );
  }

  void _cargarHistorial( String usuarioID ) async{

    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(),
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje( dynamic payload){

    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text( usuarioPara.nombre.substring(0,2), style: TextStyle(fontSize: 12),),
            ),
            SizedBox(height: 3,),
            Text(usuarioPara.nombre, style: TextStyle(fontSize: 12),)

          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                physics: BouncingScrollPhysics(),
                reverse: true,
                )
              ),
              Divider( height: 1,),
              //Caja de Texto
              Container(
                color: Colors.white,
                height: 50,
                child: _inputChat(),
              )
          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  setState(() {
                    if(texto.trim().length > 0){
                      _estaEscribiendo = true;
                    }else{
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
              ),
              //Boton de enviar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                ? CupertinoButton(
                  onPressed: _estaEscribiendo
                        ? () => _handleSubmit( _textController.text.trim() )
                        : null, 
                  child: Text('Enviar'), 
                  )
                : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData( color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      onPressed: _estaEscribiendo
                        ? () => _handleSubmit( _textController.text.trim() )
                        : null, 
                    ),
                  ),
                ),
              )
          ]
          )
      ),
    );
  }


  _handleSubmit( String texto){

    if( texto.isEmpty ) return ;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto, 
      uid: authService.usuario!.uid,
      animationController: AnimationController(vsync: this, duration: (Duration(milliseconds: 200))),
      );

    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() { _estaEscribiendo = false; });

    socketService.emit('mensaje-personal', {
      'de':authService.usuario!.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto
    });

  }


  @override
  void dispose() {

    //Limpiar instancias
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    // Off del socket
    socketService.socket.off('mensaje-personal');

    super.dispose();
  }
}