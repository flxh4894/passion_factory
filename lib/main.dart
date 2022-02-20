import 'package:firebase_core/firebase_core.dart';
import 'package:passion_factory/app_initialize.dart';
import 'package:passion_factory/app.dart';
import 'package:passion_factory/singleton.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 0. Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1. Singleton 초기화
  singletonSetup();

  runApp(AppInitialize(childWidget: MyApp()));
}
