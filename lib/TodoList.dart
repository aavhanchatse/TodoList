import 'package:blockchain_demo/TodoListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  String? text;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: provider.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: provider.todo.isEmpty
                      ? Center(
                          child: Text('no todos added yet'),
                        )
                      : ListView.builder(
                        itemCount: provider.todo.length,
                          itemBuilder: (context, index) {
                            return Text(
                                provider.todo[index].taskName.toString());
                          },
                        ),
                ),
                Container(
                  color: Colors.blue[100],
                  child: Row(
                    children: [
                      Expanded(child: TextField(
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                      )),
                      InkWell(
                        onTap: (){
                           print('onTap');
                                provider.addTask(text.toString());
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                            color: Colors.pink,
                          child: Icon(
                             Icons.add,
                            ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
