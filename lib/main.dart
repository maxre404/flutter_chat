import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  final  inputController = TextEditingController();

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _webSocketLogin(){
    var inputText = inputController.text;
    if(inputText.isNotEmpty){
      try {
        final channel = WebSocketChannel.connect(
                // Uri.parse('ws://localhost:8080/websocket/$inputText'),
                Uri.parse('ws://localhost:8080/websocket/username'),
              );
        channel.stream.listen((event) {
          print('连接成功');
        },onDone: (){
          print('finish');
        });
      } catch (e) {
        print(e);
        print('连接失败:$e');
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
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 20,right: 20),
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
              MaterialButton(onPressed: _webSocketLogin,
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