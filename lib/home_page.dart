import 'package:flutter/material.dart';

import 'Commond.dart';
import 'Singleton.dart';
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
    Singleton.getInstance().channel?.sink.add(onlineUser);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: const Text("在线列表"),
      ),
      body: StreamBuilder(
        stream: Singleton.getInstance().channel?.stream,
        builder: (context, snapshot) {
          return Text(snapshot.hasData ? '${snapshot.data}' : '');
        }
      ),
    );
  }
}
