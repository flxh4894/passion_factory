import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passion_factory/main.dart';
import 'package:passion_factory/model/room.dart';
import 'package:passion_factory/page/chat_room.dart';
import 'package:passion_factory/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('내 채팅 목록'),
        ),
        body: Consumer<ChatProvider>(
          builder: (_, state, __) => StreamBuilder(
            stream: state.stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              if (snapshot.data == null) {
                return Container();
              }

              final rooms = snapshot.data!.docs
                  .map((e) => Room.fromJson(e.data()))
                  .toList();

              return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) =>
                      _chatRoomComponent(rooms[index]));
            },
          ),
        ));
  }

  Widget _chatRoomComponent(Room room) {
    return Consumer<ChatProvider>(
      builder: (context, state, __) => FutureBuilder(
        future: state.roomNameMapping(room.roomId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container();
          }

          return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ChatRoomPage.routePath, arguments: {
              'uid': '',
              'nickname': snapshot.data as String,
              'roomId': room.roomId,
            });
          },
          child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (snapshot.data as String),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        room.lastMsg,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios)
                ],
              )),
        );
        },
      ),
    );
  }
}
