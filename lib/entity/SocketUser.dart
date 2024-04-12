
import 'dart:core';

class SocketUser{
   String userId = "";
   String name="";
   String sessionId="";
   String imgUrl="";

   SocketUser(this.userId,this.name, this.sessionId, this.imgUrl);

   factory SocketUser.fromJson(Map<String, dynamic> json){
      return SocketUser(json["userId"],json["name"], json["sessionId"], json["imgUrl"]);
   }
}