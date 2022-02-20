import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:passion_factory/page/chat_room.dart';
import 'package:passion_factory/page/user_join_page.dart';
import 'package:passion_factory/provider/chat_provider.dart';
import 'package:passion_factory/repository/chat_repository.dart';
import 'package:passion_factory/repository/user_repository.dart';
import 'package:provider/provider.dart';

class UserSelectPage extends StatelessWidget {
  const UserSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('유저선택'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<ChatProvider>().getAllUserList();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                GetIt.I.get<UserRepository>().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, UserJoinPage.routePath, (route) => false);
              },
              child: const Text('로그아웃')),
          Consumer<ChatProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: value.userList.length,
                  itemBuilder: (context, index) => userInfo(
                      value.userList[index].nickname,
                      value.userList[index].uid!,
                      context),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget userInfo(String nickname, String uid, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("채팅 시작 안내"),
                  content: Text('$nickname 과 채팅을 할까요?'),
                  actions: [
                    ElevatedButton(
                      child: const Text('취소'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text('네'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ChatRoomPage.routePath,
                            arguments: {
                              'uid': uid,
                              'nickname': nickname,
                            });
                      },
                    )
                  ],
                ));
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
            Text(
              nickname,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
