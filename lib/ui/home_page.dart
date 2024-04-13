import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat/entity/SocketUser.dart';
import 'package:flutter_chat/ui/chat_page.dart';
import 'package:flutter_chat/ui/group_chate_page.dart';

import '../Command.dart';
import '../Singleton.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String nickName;

  const HomePage({super.key, required this.nickName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userList = [];

  @override
  void initState() {
    super.initState();
    String onlineUser = '{"cmd":"$cmdGetOnlineUser_100"}';
    Singleton.getInstance().streamController.stream.listen((event) {
      try {
        String jsonData = event.toString();
        print('打印收到的json数据:$jsonData');
        Map<String, dynamic> jsonMap = jsonDecode(jsonData);
        int cmd = jsonMap["cmd"];
        print('cmd:$cmd');
        switch (cmd) {
          case cmdUserInfo_99:
           var  socketUser = SocketUser.fromJson(jsonMap["data"]);
           if(socketUser.userId!=Singleton.getInstance().mySelf?.userId){
             userList.add(socketUser);
             updateUi();
           }
           print('新用户上线:$socketUser');
            // Singleton.getInstance().mySelf = SocketUser.fromJson(jsonMap["data"]);
            break;
          case cmdGetOnlineUser_100:
            List<dynamic> data = jsonMap["data"];
            for (var element in data) {
              var socketUser = SocketUser.fromJson(element);
              if(socketUser.userId!=Singleton.getInstance().mySelf?.userId){
                userList.add(socketUser);
              }
            }
            updateUi();
            break;
        }
        print(jsonMap.toString());
        // int cmd = jsonMap["cmd"];
        // print("获取cmd:$cmd");
      } catch (e) {
        print("异常:$e");
      }
    });
    Singleton.getInstance().channel?.sink.add(onlineUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("在线列表"),
        leading: null,
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            SocketUser onlineUser = userList[index];
            return MaterialButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => ChatPage(chatUser: onlineUser,),
                    builder: (context){
                      if(onlineUser.type==0){
                        return GroupChatPage(chatUser: onlineUser);
                      }else{
                        return ChatPage(chatUser: onlineUser,);
                      }

                    }
                  ),
                )
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        onlineUser.imgUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    Column(
                      children: [
                        Text(
                          onlineUser.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    )
                  ],
                ),
              ),

            );
          },
          itemCount: userList.length),
    );
  }
  void updateUi(){
    setState(() {

    });
  }
}
