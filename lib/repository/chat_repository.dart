import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:passion_factory/main.dart';
import 'package:passion_factory/model/message.dart';
import 'package:passion_factory/model/room.dart';
import 'package:passion_factory/repository/user_repository.dart';

class ChatRepository {
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('Messages');
  final CollectionReference rooms =
      FirebaseFirestore.instance.collection('Rooms');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference participants =
      FirebaseFirestore.instance.collection('Participants');
  final UserRepository _userRepository = GetIt.I.get<UserRepository>();

  List<String> roomIdList = [];

  /*
  * 키페어 유무 체크
  * */
  Future checkKeypair(String keypair) async {
    return await rooms
        .where('keypair', isEqualTo: keypair)
        .get()
        .then((value) => value.docs);
  }

  /*
  * 채팅방 생성
  * */
  Future<String> createRoom(Map<String, dynamic> params) async {
    final String roomId = await rooms.add(params).then((value) => value.id);
    await rooms.doc(roomId).update({'room_id': roomId});

    return roomId;
  }

  /*
  * 메세지 불러오기
  * */
  Future getMessageList(String roomId) async {
    return messages
        .where('room_id', isEqualTo: roomId)
        .orderBy('created_at', descending: true)
        .limit(100)
        .get()
        .then((value) =>
            value.docs.map((e) => Message.fromJson(e.data())).toList());
  }

  /*
  * 메세지 보내기
  * */
  Future<void> sendMessage(Message messageModel, String roomId) async {
    messages.add(messageModel.toJson());
    rooms.doc(roomId).update({
      'last_msg': messageModel.message,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  /*
  * 메세지 스냅샷 생성
  * */
  Stream<QuerySnapshot> getMessageSnapshot(String roomId) {
    return messages
        .where('room_id', isEqualTo: roomId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  /*
  * 참가자 정보 생성
  * */
  Future<void> createParticipant(String roomId, List<String> idList) async {
    await participants.add({'users': idList, 'room_id': roomId});
  }

  /*
  * 내가 속한 채팅방 가져오기
  * */
  Future<List<Room>?> getAllRoomList() async {
    logger.i("내가 속한 채팅방 가져오기 ");
    try {
      final snapshot = await participants
          .where("users", arrayContainsAny: [_userRepository.myUid])
          .get()
          .then((value) => value.docs);

      roomIdList.clear();
      for (var element in snapshot) {
        final roomId = (element.data() as Map<String, dynamic>)['room_id'];
        roomIdList.add(roomId);
      }

      return null;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  /*
  * 채팅방 업데이트 감지
  * */
  Stream<QuerySnapshot> getChatRoomListStream() {
    logger.i("채팅방 스냅샷 생성");

    return rooms
        .where('room_id', whereIn: roomIdList)
        .orderBy('updated_at', descending: true)
        .snapshots();
  }

  /*
  * 방이름 매핑
  * */
  Future<String> roomNameMapping(String roomId) async {
    final List tempUsers = await participants
        .where('room_id', isEqualTo: roomId)
        .get()
        .then((value) => value.docs);
    final List tempUser = tempUsers.first.data()['users'];
    final String myUid = _userRepository.myUid;

    String yourId = '';
    for (String element in tempUser) {
      if (element != myUid) {
        yourId = element;
      }
    }

    final userInfo = await users
        .where('uid', isEqualTo: yourId)
        .get()
        .then((value) => value.docs);

    return (userInfo.first.data() as Map<String, dynamic>)['nickname'];
  }
}
