import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/entity/Message.dart';
import 'package:flutter_chat/http/ApiService.dart';

import '../Singleton.dart';
import '../entity/SocketUser.dart';
import 'package:flutter_chat/Command.dart';

class GroupChatPage extends StatefulWidget {
  final SocketUser chatUser;//聊天对象
  const GroupChatPage({super.key,required this.chatUser});

  @override
  State<GroupChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<GroupChatPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    getMessageList();
    Singleton.getInstance().streamController.stream.listen((event) {
      String jsonData = event.toString();
      Map<String, dynamic> jsonMap = jsonDecode(jsonData);
      int cmd = jsonMap["cmd"];
      if(cmd == cmdChat101){
        var message = Message.fromJson(jsonMap["data"]);
        if(message.type==0){
          _messages.insert(0, message);
          updateUi();
        }
      }
    });
    super.initState();
  }
  Future<void> getMessageList() async {
    List<dynamic> messageList = await ApiService().post("/messageList", {"type":"0","groupId":"$chatGroupId","fromUser":"","toUser":""}) ;
    print('获取结果:$messageList');
    for (var element in messageList) {
      // _messages.add(Message.fromJson(element));
      _messages.insert(0, Message.fromJson(element));
    }
    if(messageList.isNotEmpty){
      updateUi();
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    String message = '{"cmd":"$cmdChat101","type":"0","fromUser":"${Singleton.getInstance().mySelf?.userId}","fromUserName":"${Singleton.getInstance().mySelf?.userName}","toUser":"","groupId":"${widget.chatUser.groupId}","message":"$text"}';
    Singleton.getInstance().channel?.sink.add(message);
    // setState(() {
    //   _messages.insert(0, text);
    // });
  }
  void updateUi(){
    if(mounted){
      setState(() {
      });
    }
}

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget?.chatUser.name}'),
          elevation: 4
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                if(message.fromUser == Singleton.getInstance().mySelf?.userId){
                  return  Padding(padding: const EdgeInsets.all(10),child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(message.message),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          Singleton.getInstance().mySelf?.imgUrl??"",
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  )
                    ,);
                }else{
                  return Padding(padding: const EdgeInsets.all(10),child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          message.imgUrl??"",
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Text("${message.fromUserName}:\n${message.message}")
                    ],
                  ),);
                }
              },
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
    ;
  }
}
