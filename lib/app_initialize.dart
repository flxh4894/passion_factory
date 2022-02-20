import 'package:flutter/material.dart';
import 'package:passion_factory/provider/chat_provider.dart';
import 'package:passion_factory/provider/root_provider.dart';
import 'package:provider/provider.dart';

class AppInitialize extends StatelessWidget {
  const AppInitialize({
    Key? key,
    required this.childWidget,
  }) : super(key: key);

  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RootProvider>(create: (_) => RootProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
      ],
      child: childWidget,
    );
  }
}
