import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/configs/Constant.dart';

class TodoCard extends StatefulWidget {
  String title;
  String description;
  bool status;
  String image;
  String createdAt;

  TodoCard(
      {required this.title,
      required this.description,
      required this.status,
      required this.image,
      required this.createdAt});

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
      width: 500,
      // height: 400,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            child: Image.network(
              '$URL_BASE/${widget.image}',
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.status = !widget.status;
                });
              },
              child: Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                color: widget.status ? Colors.green : Colors.redAccent,
                // elevation: 10,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor:
                              widget.status ? Colors.green : Colors.redAccent,
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: widget.status,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.status = !widget.status;
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
                                      widget.title,
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
                                          DateTime.parse(widget.createdAt)),
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
                                widget.description,
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
