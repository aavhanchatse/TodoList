import 'package:blockchain_demo/TodoListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListModel>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
    );
  }
}
