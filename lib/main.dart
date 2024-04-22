import 'package:flutter/material.dart';
import 'package:task/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) =>
      Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              backgroundColor:Colors.white,
              color: Color(0xFFB32073),
            )
        ),
      );
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

