import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [
    // ChatMessage(texto: 'Hola Mundo1', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo2', uid: '12'),
    // ChatMessage(texto: 'Hola Mundo3', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo4', uid: '13'),
    // ChatMessage(texto: 'Hola Mundo5', uid: '123'),
  ];

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text('Melissa', style: TextStyle(fontSize: 12),)

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
                  child: Text('Enviar'), 
                  onPressed: _estaEscribiendo
                        ? () => _handleSubmit( _textController.text.trim() )
                        : null, 
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

    if( texto.length == 0 ) return ;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      texto: texto, 
      uid: '123',
      animationController: AnimationController(vsync: this, duration: (Duration(milliseconds: 200))),
      );

    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

  }


  @override
  void dispose() {
    // TODO: implement dispose

    // Off del socket

    //Limpiar instancias
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    super.dispose();
  }
}