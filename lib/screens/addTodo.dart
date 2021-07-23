import 'dart:io' as IO;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/services/todo.service.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  XFile? _image;
  final _formKey = GlobalKey<FormState>();

  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String _todoTitle = '';
    String _todoDescription = '';
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
      onChanged: (value) {
        _todoDescription = value;
      },
    );

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Add Todo"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 32,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => {_showPicker(context)},
                        child: Container(
                          child: _image != null
                              ? ClipRRect(
                                  child: Image.file(
                                    IO.File(_image!.path),
                                    width: 500,
                                    height: 250,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  width: 500,
                                  height: 250,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 10),
                      titleField,
                      SizedBox(height: 10),
                      descriptionField,
                      SizedBox(height: 10),
                      // SizedBox(
                      //   width: 500,
                      //   child: ElevatedButton(
                      //     style:
                      //         ElevatedButton.styleFrom(primary: Colors.green),
                      //     onPressed: () {
                      //       _showPicker(context);
                      //     },
                      //     child: Text(
                      //       "Pick Image",
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 10),
                      SizedBox(
                        width: 500,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              FormData formData = FormData.fromMap({
                                'title': _todoTitle,
                                'description': _todoDescription,
                                'image': await MultipartFile.fromFile(
                                    _image!.path,
                                    filename: _image!.name)
                              });
                              EasyLoading.show();
                              final result =
                                  await TodoService.addTodo(formData);
                              EasyLoading.dismiss();
                              if (result['data'] != null) {
                                Navigator.of(context).pop(true);
                              }
                            } catch (e) {
                              EasyLoading.dismiss();
                              print(e);
                            }
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
              )
            ],
          ),
        ));
  }
}
