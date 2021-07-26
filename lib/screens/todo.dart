import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_app/components/todoCard.component.dart';
import 'package:my_app/controllers/todo.controller.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final todoController = Get.put<TodoController>(TodoController());

  _buildListView() {
    return Obx(() {
      var todos = todoController.todos;
      RxBool isLoading = todoController.isLoading;
      if (todos.length == 0 && !isLoading.value) {
        return Center(child: Text('Nothing to do'));
      }
      return RefreshIndicator(
          onRefresh: _getTodos,
          child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return TodoCard(todo: todos.elementAt(index));
                  })));
    });
  }

  Future<void> _getTodos() async {
    try {
      EasyLoading.show();
      await todoController.getList();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print("Error _getTodos");
    }
  }

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Todo Page",
        home: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text("Todo"),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: "Add Todo",
              child: Icon(Icons.add),
              backgroundColor: Colors.red,
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/addTodo');
                if (result != null) {
                  await _getTodos();
                }
              },
            ),
            body: _buildListView()));
  }
}
