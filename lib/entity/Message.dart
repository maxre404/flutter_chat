
class Message{
  int type = 1;//聊天类型，0群聊，1单聊；
  String fromUser = "";//发送者
  String toUser = "";//接收者；（可以是用户名等）session.getId（）
  String message = "";

  Message(this.type, this.fromUser, this.toUser, this.message); //消息


  factory Message.fromJson(Map<String, dynamic> json){
    return Message(json["type"], json["fromUser"], json["toUser"],json["message"]);
  }

}