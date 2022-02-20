import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:passion_factory/main.dart';
import 'package:passion_factory/page/root_page.dart';
import 'package:passion_factory/page/user_join_page.dart';
import 'package:passion_factory/repository/user_repository.dart';
import 'package:passion_factory/routes.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final UserRepository _userRepository = GetIt.I.get<UserRepository>();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '열정팩토리 채팅',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffffffff),
        primaryColor: const Color(0xff7c37fa),
      ),
      routes: routes,
      initialRoute: _userRepository.auth.currentUser == null ? UserJoinPage.routePath : RootPage.routePath,
    );
  }
}
