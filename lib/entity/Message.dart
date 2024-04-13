
import 'dart:convert';

class Message{
  int type = 1;//聊天类型，0群聊，1单聊；
  String fromUser = "";//发送者
  String fromUserName = "";//发送这名字
  String toUser = "";//接收者；（可以是用户名等）session.getId（）
  String message = "";
  String? imgUrl = "";//头像地址 目前只有群聊用到了
  Message(this.type, this.fromUser,this.fromUserName, this.toUser, this.message,this.imgUrl); //消息


  factory Message.fromJson(Map<String, dynamic> json){
    return Message(json["type"], json["fromUser"], json["fromUserName"],json["toUser"],json["message"],json["imgUrl"]);
  }

}