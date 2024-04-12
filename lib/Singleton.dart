import 'dart:async';

import 'package:flutter_chat/entity/UserLogin.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'entity/SocketUser.dart';

class Singleton {
  // 声明一个私有的静态变量_instance，用来保存单例实例
  static Singleton? _instance;

  // 声明一个私有的工厂构造函数，用来创建单例实例
  Singleton._();

  // 公开的静态方法，用来获取单例实例
  static Singleton getInstance() {
    // 如果_instance为空，说明尚未创建单例实例，则创建一个新的实例并赋值给_instance
    // 如果_instance不为空，则直接返回_instance
    _instance ??= Singleton._();
    return _instance!;
  }

  WebSocketChannel? channel;
  final streamController = StreamController.broadcast();

  // SocketUser? mySelf;
  UserLogin? mySelf;

}
