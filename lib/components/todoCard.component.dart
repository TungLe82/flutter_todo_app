import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/configs/Constant.dart';
import 'package:my_app/controllers/todo.controller.dart';
import 'package:my_app/models/todo.model.dart';
import 'package:my_app/services/toast.dart';

class TodoCard extends StatefulWidget {
  final MTodo todo;
  TodoCard({required this.todo});

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  final todoController = Get.put<TodoController>(TodoController());

  Color getColor(Set<MaterialState> states) {
    return Colors.white;
  }

  _showPopupMenu(Offset offset, id) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        if (widget.todo.status != TODO_STATUS["CANCEL"])
          PopupMenuItem<String>(
              child: GestureDetector(
            child: const Text('Cancel'),
            onTap: () async {
              try {
                EasyLoading.show();
                await todoController.changeStatus(id, TODO_STATUS["CANCEL"]);
                EasyLoading.dismiss();
                Navigator.pop(context);
              } catch (e) {
                EasyLoading.dismiss();
              }
            },
          )),
        PopupMenuItem<String>(
            child: GestureDetector(
          child: const Text('Delete'),
          onTap: () async {
            try {
              EasyLoading.show();
              await todoController.delete(id);
              EasyLoading.dismiss();
              Navigator.pop(context);
              showToast(text: "Delete success.");
            } catch (e) {
              EasyLoading.dismiss();
            }
          },
        )),
      ],
      elevation: 8.0,
    );
  }

  Color _getColorByStatus(status) {
    if (status == TODO_STATUS["IN_PROGRESS"]) {
      return Colors.blueAccent;
    } else if (status == TODO_STATUS["COMPLETED"]) {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
  }

  getNextStatus(status) {
    if (status == TODO_STATUS["IN_PROGRESS"]) {
      return TODO_STATUS["COMPLETED"];
    } else if (status == TODO_STATUS["COMPLETED"]) {
      return TODO_STATUS["IN_PROGRESS"];
    } else {
      return TODO_STATUS["IN_PROGRESS"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 500,
      // height: 400,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            // spreadRadius: 0.2,
            blurRadius: 5,
            // offset: Offset(0, 0.1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Stack(children: <Widget>[
                Positioned(
                    child: Image.network(
                  '$URL_BASE/${widget.todo.image}',
                  height: 300,
                  width: 500,
                  fit: BoxFit.cover,
                )),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _showPopupMenu(details.globalPosition, widget.todo.id);
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: 30,
                    ),
                  ),
                )
              ])),
          GestureDetector(
              onTap: () async {
                try {
                  EasyLoading.show();
                  await todoController.changeStatus(
                      widget.todo.id, getNextStatus(widget.todo.status));
                  EasyLoading.dismiss();
                } catch (e) {
                  EasyLoading.dismiss();
                }
              },
              child: Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                color: _getColorByStatus(widget.todo.status),
                // elevation: 10,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        widget.todo.status == TODO_STATUS["CANCEL"]
                            ? Container(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.clear_outlined),
                              )
                            : Checkbox(
                                checkColor: Colors.white,
                                activeColor:
                                    _getColorByStatus(widget.todo.status),
                                // fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: widget.todo.status ==
                                    TODO_STATUS["COMPLETED"],
                                onChanged: (bool? value) async {
                                  try {
                                    EasyLoading.show();
                                    await todoController.changeStatus(
                                        widget.todo.id,
                                        getNextStatus(widget.todo.status));
                                    EasyLoading.dismiss();
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                  }
                                },
                              )
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      widget.todo.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      DateFormat('HH:mm dd/MM/yyyy').format(
                                          DateTime.parse(
                                              widget.todo.createdAt)),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                widget.todo.description,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
