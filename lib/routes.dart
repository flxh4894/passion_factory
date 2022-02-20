import 'package:flutter/material.dart';
import 'package:passion_factory/page/chat_room.dart';
import 'package:passion_factory/page/root_page.dart';
import 'package:passion_factory/page/user_join_page.dart';

final Map<String, WidgetBuilder> routes = {
  RootPage.routePath: (context) => const RootPage(),
  ChatRoomPage.routePath: (context) => ChatRoomPage(),
  UserJoinPage.routePath: (context) => UserJoinPage(),
};