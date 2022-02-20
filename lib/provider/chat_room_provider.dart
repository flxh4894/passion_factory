import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:passion_factory/main.dart';
import 'package:passion_factory/model/message.dart';
import 'package:passion_factory/repository/chat_repository.dart';
import 'package:passion_factory/repository/user_repository.dart';

/*
* 채팅방 진입시 지역으로 초기화
* */
class ChatRoomProvider extends ChangeNotifier {

  ChatRoomProvider({required this.yourUid, required this.roomId}) {
    myUid = _userRepository.myUid;
    _init();
  }

  final UserRepository _userRepository = GetIt.I.get<UserRepository>();
  final ChatRepository _chatRepository = GetIt.I.get<ChatRepository>();

  final String yourUid;
  late final String myUid;

  String? roomId; // 처음 생성시에는 RoomID 존재하지 않음.
  Stream<QuerySnapshot>? stream;

  /*
  * 채팅방 생성 및 채팅 내역 불러오기
  * */
  Future<void> _init() async {
    // 해쉬 값이 큰 값이 앞으로 오도록 하여 키페어 생성
    final String keyPair = makeKeyPair();

    // 해당 키페어의 채팅방이 있는지 확인
    final roomInfo = await _chatRepository.checkKeypair(keyPair);

    if(roomId == null ){
      if (roomInfo.isEmpty) {
        // 키페어가 없다면 채팅방 생성, 참여자 정보 생성
        final params = {
          'keypair': keyPair,
          'last_msg': '',
          'created_at': DateTime.now().millisecondsSinceEpoch,
        };
        roomId = await _chatRepository.createRoom(params);
        await _chatRepository.createParticipant(roomId!,  [myUid, yourUid]);
      } else {
        roomId = roomInfo.first.id;
      }
    }

    stream = setMessageStream();
    notifyListeners();
  }

  // 채팅 방에 있기 때문에 Stream 형식으로 실시간 데이터 받아오기.
  Stream<QuerySnapshot> setMessageStream() {
    logger.i("메세지 스트림 설정 $roomId");
    return _chatRepository.getMessageSnapshot(roomId!);
  }

  /*
  * [나 - 상대] 키페어로 생성된 방이 있는지 확인
  * 키페어 생성 => uid sort 로 순차 적용
  * */
  String makeKeyPair() {
    return myUid.hashCode > yourUid.hashCode
        ? '${myUid.hashCode}-${yourUid.hashCode}'
        : '${yourUid.hashCode}-${myUid.hashCode}';
  }

  /*
  * 메세지 보내기
  * */
  Future<void> sendMessage(String message) async {
    try {
      final Message messageModel = Message(
        message: message,
        roomId: roomId!,
        sendUser: myUid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _chatRepository.sendMessage(messageModel, roomId!);
    } catch (e) {
      logger.e(e);
    }
  }
}
