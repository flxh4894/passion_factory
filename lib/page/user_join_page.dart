import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:passion_factory/model/user.dart';
import 'package:passion_factory/page/root_page.dart';
import 'package:passion_factory/provider/chat_provider.dart';
import 'package:passion_factory/repository/chat_repository.dart';
import 'package:passion_factory/repository/user_repository.dart';
import 'package:provider/provider.dart';

class UserJoinPage extends StatelessWidget {
  static String routePath = "/join";
  UserJoinPage({Key? key}) : super(key: key);

  final TextEditingController email = TextEditingController();
  final TextEditingController pw = TextEditingController();
  final TextEditingController nickname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('회원가입 및 로그인'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: email,
            keyboardType: TextInputType.text,
            obscureText: false,
            decoration: const InputDecoration(
              hintText: 'E-mail'
            ),
          ), // ID
          TextFormField(
            controller: pw,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: 'PW'
            ),
          ), // PW
          TextFormField(
            controller: nickname,
            decoration: const InputDecoration(
                hintText: 'nickname'
            ),
          ), // nickname
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () async {
                 UserRepository repository = GetIt.I.get<UserRepository>();
                 await repository.joinApp(user: User(email: email.text, pw: pw.text, uid: null, nickname: nickname.text));

                 await context.read<ChatProvider>().init();
                 Navigator.pushNamedAndRemoveUntil(context, RootPage.routePath, (route) => false);

              }, child: const Text('회원가입')),
              ElevatedButton(onPressed: () async {
                UserRepository repository = GetIt.I.get<UserRepository>();
                await repository.loginApp(user: User(email: email.text, pw: pw.text, uid: null, nickname: nickname.text));

                await context.read<ChatProvider>().init();
                Navigator.pushNamedAndRemoveUntil(context, RootPage.routePath, (route) => false);

              }, child: const Text('로그인')),
            ],
          )
        ],
      ),
    );
  }
}
