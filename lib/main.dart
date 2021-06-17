import 'package:blockchain_demo/TodoList.dart';
import 'package:blockchain_demo/TodoListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          
          primarySwatch: Colors.blue,
        ),
        home: TodoList(),
      ),
    );
  }
}

