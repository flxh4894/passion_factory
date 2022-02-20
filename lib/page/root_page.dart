import 'package:flutter/material.dart';
import 'package:passion_factory/main.dart';
import 'package:passion_factory/page/rooms_page.dart';
import 'package:passion_factory/page/users_page.dart';
import 'package:passion_factory/provider/root_provider.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  static String routePath = "/root";
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(
      builder: (_, state, __) => Scaffold(
        body: IndexedStack(
          index: state.index,
          children: const [
            UserSelectPage(),
            RoomsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: state.index,
          onTap: (int index) => context.read<RootProvider>().changeIndex(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), label: "사용자"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "채팅목록"),
          ],
        ),
      ),
    );
  }
}
