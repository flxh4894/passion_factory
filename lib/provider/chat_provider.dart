import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:passion_factory/main.dart';
import 'package:passion_factory/model/room.dart';
import 'package:passion_factory/model/user.dart';
import 'package:passion_factory/repository/chat_repository.dart';
import 'package:passion_factory/repository/user_repository.dart';

class ChatProvider extends ChangeNotifier{

  ChatProvider(){
    init();
  }

  final UserRepository _userRepository = GetIt.I.get<UserRepository>();
  final ChatRepository _chatRepository = GetIt.I.get<ChatRepository>();
  List<User> _userList = [];
  List<User> get userList => _userList;
  List<Room> roomList = [];
  Stream<QuerySnapshot>? stream;

  Future<void> init() async {
    await getAllUserList();
    await _chatRepository.getAllRoomList();
    stream = _chatRepository.getChatRoomListStream();
    notifyListeners();
  }

  /*
  * 모든 유저 가져오기
  * */
  Future<void> getAllUserList() async {
    logger.i("모든 유저 가져오기");

    try {
      List<User>? userList = await _userRepository.getAllUserList();
      if(userList != null) {
        _userList = userList;
      }

      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  /*
  * 방 이름 매핑
  * */
  Future<String> roomNameMapping(String roomId) async {
    return await _chatRepository.roomNameMapping(roomId);
  }
}