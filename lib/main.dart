import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'Home_page.dart';
import 'model.dart';

// const todosBoxName = "desai";

const String boxName = "boxOfNotes";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.registerAdapter(NotesModelAdapter());
  Hive.init(directory.path);
  await Hive.openBox<NotesModel>(boxName);

  /// Home page
  await Hive.openBox<String>("todo");
  // await Hive.openBox<String>("Todos");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home_page(),
    );
  }
}
