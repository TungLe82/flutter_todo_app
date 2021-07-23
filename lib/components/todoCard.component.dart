import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/configs/Constant.dart';
import 'package:my_app/models/todo.model.dart';

class TodoCard extends StatefulWidget {
  final MTodo todo;
  TodoCard({required this.todo});

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  DateFormat dateFormat = DateFormat("HH:mm dd/MM/YYYY");

  Color getColor(Set<MaterialState> states) {
    return Colors.white;
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
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            child: Image.network(
              '$URL_BASE/${widget.todo.image}',
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.todo.status = !widget.todo.status;
                });
              },
              child: Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                color: widget.todo.status ? Colors.green : Colors.redAccent,
                // elevation: 10,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: widget.todo.status
                              ? Colors.green
                              : Colors.redAccent,
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: widget.todo.status,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.todo.status = !widget.todo.status;
                            });
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
