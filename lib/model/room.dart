class Room {
  Room({
    required this.lastMsg,
    required this.keypair,
    required this.createdAt,
    required this.roomId,
  });

  final String lastMsg;
  final String keypair;
  final int createdAt;
  final String roomId;

  factory Room.fromJson(json) => Room(
        lastMsg: json['last_msg'],
        keypair: json['keypair'],
        createdAt: json['created_at'],
        roomId: json['room_id'],
      );
}
