import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/api.service.dart';
import 'package:my_app/services/setTimeOut.dart';
import 'package:my_app/services/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a valid name.';
        }
        return null;
      },
      onChanged: (value) => _name = value,
    );

    final emailField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide an valid email.';
        }
        if (!EmailValidator.validate(value)) {
          return 'Please provide an valid email.';
        }
        return null;
      },
      onChanged: (value) => _email = value,
    );

    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Password is required';
        }
        if (value.trim().length < 6) {
          return 'Password must be at least 6 characters in length.';
        }
        return null;
      },
      onChanged: (value) => _password = value,
    );

    final confirmPasswordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Confirm password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Confirm Password is required';
        }
        if (value.trim().length < 6) {
          return 'Confirm Password must be at least 6 characters in length.';
        }
        if (value.trim() != _password) {
          return 'Confirm Password must be same as Password.';
        }
        return null;
      },
    );

    final registerBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text('Processing Data')));
            try {
              final user = await API.registerService(
                  {"name": _name, "email": _email, "password": _password});
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('token', user.token);
              Navigator.pushNamed(context, '/todo');
            } catch (e) {
              showToast(text: "Register failed!", color: Colors.red);
            }
          }
        },
        child: Text("Register",
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    nameField,
                    SizedBox(
                      height: 25.0,
                    ),
                    emailField,
                    SizedBox(
                      height: 25.0,
                    ),
                    passwordField,
                    SizedBox(
                      height: 25.0,
                    ),
                    confirmPasswordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    registerBtn,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
