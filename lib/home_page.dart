import 'dart:async';

import 'package:flutter/material.dart';

import 'Command.dart';
import 'Singleton.dart';
import 'dart:convert';


class HomePage extends StatefulWidget {
  final String nickName;
  const HomePage({super.key, required this.nickName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    String onlineUser = '{"cmd":"$cmdGetOnlineUser"}';
    Singleton.getInstance().streamController.stream.listen((event) {
      try {
        print('+++++++++++++');
        Map<String, dynamic> jsonMap = JsonDecoder(event) as Map<String, dynamic>;
        int cmd = jsonMap["cmd"];
        print("获取cmd:$cmd");
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
      ),
      body:  Column(
        children: [
          StreamBuilder(
              stream: Singleton.getInstance().streamController.stream,
              builder: (context, snapshot) {
                print('11113:${snapshot.data}');
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              }),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    );
  }
}
