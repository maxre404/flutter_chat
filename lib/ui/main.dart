import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/entity/UserLogin.dart';
import 'package:flutter_chat/ui/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_chat/http/Api.dart';

import '../Singleton.dart';
import 'package:flutter_chat/Extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController(text: "jkl");
  Future<void> _webSocketLogin() async {
     var inputText = inputController.text;
    if (inputText.isNotEmpty) {
      try {
        var dio = Dio();
        dio.options.baseUrl = baseApi;
        // 发起 POST 请求
        Response response = await dio.post('/login', data: {
          'userName': inputText,
        });
        if (response.statusCode == 200) {
          print('http请求成功:${response.data}');
          var userId = response.data["userId"];
          var userName = response.data["userName"];
          var imgUrl = response.data["imgUrl"];
          Singleton.getInstance().mySelf = UserLogin(userId, userName,imgUrl);
          final channel = WebSocketChannel.connect(
            Uri.parse('$baseWebSocket$userId/$inputText'),
            // Uri.parse('ws://localhost:8080/ok/$userId/$inputText'),
            // Uri.parse('ws://192.168.1.252:8080/websocket/$inputText'),
            // Uri.parse('ws://192.192.191.104:8080/websocket/$inputText'),
          );
          await channel.ready;
          print('websocket连接成功');
          Singleton.getInstance().channel = channel;
          Singleton.getInstance().streamController.addStream(channel.stream);
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                nickName: inputText,
              ),
            ),
          );

        }else{
          print('处理失败');
        }
      } catch (e) {
        print(e);
        print('连接失败:$e');
        Fluttertoast.showToast(msg: "$e",gravity: ToastGravity.CENTER);
      }
    }
    // ws://localhost:8080
    print('打印:text:$inputText');
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
          elevation: 4
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const Padding(padding: EdgeInsets.only(left: 20,right: 20),child:
              TextField(
                controller: inputController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '请输入用户名',
                ),
              ),
              // ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              MaterialButton(
                onPressed: _webSocketLogin,
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text("登录"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
