
import 'dart:core';

class SocketUser{
   String userId = "";
   String name="";
   String sessionId="";
   String imgUrl="";
   int type = 1;//聊天类型，0群聊，1单聊；
   int groupId = 0;//群id 系统群目前是写死的 999999


   SocketUser(this.userId,this.name, this.sessionId, this.imgUrl,this.type,this.groupId);

   factory SocketUser.fromJson(Map<String, dynamic> json){
      return SocketUser(json["userId"],json["name"], json["sessionId"], json["imgUrl"],json["type"], json["groupId"]);
   }
}