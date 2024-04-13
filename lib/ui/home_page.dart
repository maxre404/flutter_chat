import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_chat/entity/SocketUser.dart';
import 'package:flutter_chat/ui/chat_page.dart';
import 'package:flutter_chat/ui/group_chate_page.dart';

import '../Command.dart';
import '../Singleton.dart';
import 'dart:convert';

import '../entity/Message.dart';

class HomePage extends StatefulWidget {
  final String nickName;

  const HomePage({super.key, required this.nickName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userList = [];
  HashMap<String,Message> messageMap=HashMap();

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
          case cmdChat101:
            var message = Message.fromJson(jsonMap["data"]);
            if(message.type==0){
              messageMap["$chatGroupId"] = message;
            }else{
              messageMap["${message.fromUser}}"];
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("在线列表"),
        leading: null,
          elevation: 24
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              SocketUser onlineUser = userList[index];
              var userId = onlineUser.type==0?"$chatGroupId":onlineUser.userId;
              var lastMessage = messageMap[userId];
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
                        mainAxisAlignment: MainAxisAlignment.start, // 左对齐
                        crossAxisAlignment: CrossAxisAlignment.start, // 交叉轴左对齐
                        children: [
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            onlineUser.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          if(null!=lastMessage) Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            lastMessage.message,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                ),

              );
            },
            separatorBuilder: (context, index){
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16), // 设置左右边距为16
                child: Divider(
                  height: 1,
                  color: Colors.grey, // 分割线颜色
                ),
              );
            },
            itemCount: userList.length),
      )
    );
  }
  void updateUi(){
    if(mounted){
      setState(() {
      });
    }
  }
}
