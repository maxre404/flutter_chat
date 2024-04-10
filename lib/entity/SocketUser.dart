
import 'dart:core';

class SocketUser{
   String name="";
   String sessionId="";
   String imgUrl="";

   SocketUser(this.name, this.sessionId, this.imgUrl);

   factory SocketUser.fromJson(Map<String, dynamic> json){
      return SocketUser(json["name"], json["sessionId"], json["imgUrl"]);
   }
}