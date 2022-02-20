class Message {
  Message({
    required this.message,
    required this.roomId,
    required this.sendUser,
    required this.createdAt,
  });

  final String message;
  final String roomId;
  final String sendUser;
  final int createdAt;

  factory Message.fromJson(json) => Message(
        message: json['message'],
        createdAt: json['created_at'],
        sendUser: json['send_user'],
        roomId: json['room_id'],
      );


  Map<String, dynamic> toJson() => {
    'message': message,
    'created_at': createdAt,
    'send_user': sendUser,
    'room_id': roomId,
  };

}
