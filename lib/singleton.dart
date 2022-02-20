import 'package:get_it/get_it.dart';
import 'package:passion_factory/repository/chat_repository.dart';
import 'package:passion_factory/repository/user_repository.dart';

final getIt = GetIt.instance;

singletonSetup() async {
  getIt.registerSingleton<UserRepository>(UserRepository());
  getIt.registerSingleton<ChatRepository>(ChatRepository());
}