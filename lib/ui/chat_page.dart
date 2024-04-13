import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/entity/Message.dart';

import '../Singleton.dart';
import '../entity/SocketUser.dart';
import 'package:flutter_chat/Command.dart';

class ChatPage extends StatefulWidget {
  final SocketUser chatUser; //聊天对象
  const ChatPage({Key? key, required this.chatUser}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    Singleton.getInstance().streamController.stream.listen((event) {
      String jsonData = event.toString();
      Map<String, dynamic> jsonMap = jsonDecode(jsonData);
      int cmd = jsonMap["cmd"];
      if (cmd == cmdChat101) {
        print('打印聊天界面收到的消息:$jsonData');
        var message = Message.fromJson(jsonMap["data"]);
        if (message.type == 1 &&
                message.fromUser == Singleton.getInstance().mySelf?.userId ||
            message.fromUser == widget.chatUser.userId) {
          _messages.insert(0, Message.fromJson(jsonMap["data"]));
          updateUi();
        }
      }
    });
    super.initState();
  }

  void updateUi() {
    setState(() {});
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    String message =
        '{"cmd":"$cmdChat101","type":"1","fromUser":"${Singleton.getInstance().mySelf?.userId}","toUser":"${widget.chatUser.userId}","message":"$text"}';
    Singleton.getInstance().channel?.sink.add(message);
    // setState(() {
    //   _messages.insert(0, text);
    // });
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
                if (message.fromUser ==
                    Singleton.getInstance().mySelf?.userId) {
                  print('自己发送的对话哦');
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(message.message),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            Singleton.getInstance().mySelf?.imgUrl ?? "",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.chatUser.imgUrl ?? "",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Text(message.message)
                      ],
                    ),
                  );
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
