import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_app/components/todoCard.component.dart';
import 'package:my_app/models/todo.model.dart';
import 'package:my_app/services/todo.service.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // MTodo _todo = MTodo();
  List<MTodo> _todos = <MTodo>[];
  final _formKey = GlobalKey<FormState>();

  // ListView _buildListView() {
  //   return ListView.builder(
  //       itemCount: _todos.length,
  //       itemBuilder: (context, index) {
  //         return TodoCard(
  //             title: _todos[index].title,
  //             description: _todos[index].description,
  //             createdAt: _todos[index].createdAt,
  //             image: _todos[index].image,
  //             status: _todos[index].status ? true : false);
  //       });
  // }

  List<Widget> _buildListView() {
    return _todos.map((todo) {
      return TodoCard(todo: todo);
    }).toList();
  }

  String _todoTitle = '';
  String _todoDescription = '';

  Future<void> _getTodos() async {
    try {
      EasyLoading.show();
      final result = await TodoService.getTodos();
      EasyLoading.dismiss();
      setState(() {
        result.sort((a, b) {
          return DateTime.parse(b.createdAt)
              .compareTo(DateTime.parse(a.createdAt));
        });
        _todos = result;
      });
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
    final titleField = TextFormField(
      obscureText: false,
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "Title",
        labelStyle: TextStyle(fontSize: 15.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a Title.';
        }
        return null;
      },
      onChanged: (value) => _todoTitle = value,
    );

    final descriptionField = TextFormField(
      obscureText: false,
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "Description",
        labelStyle: TextStyle(fontSize: 15.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a Description.';
        }
        return null;
      },
      onChanged: (value) {},
    );

    _buildDialog() async {
      return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
                title: Center(
                  child: Text("Add Todo"),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0)), //this right here
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleField,
                          SizedBox(height: 10),
                          descriptionField,
                          SizedBox(height: 10),
                          SizedBox(
                            width: 320.0,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _todos.add(MTodo(
                                      title: _todoTitle,
                                      description: _todoDescription,
                                      createdAt:
                                          DateTime.now().toIso8601String()));
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]);
          });
    }

    return MaterialApp(
      title: "Todo Page",
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Todo"),
          ),
          // actions: <Widget>[
          //   IconButton(onPressed: () => {}, icon: Icon(Icons.add))
          // ],
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
        body: RefreshIndicator(
            onRefresh: _getTodos,
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    children: _buildListView(),
                  )),
            )),
      ),
    );
  }
}
