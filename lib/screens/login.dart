import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_app/services/toast.dart';
import 'package:my_app/services/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
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
      keyboardType: TextInputType.emailAddress,
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

    final loginBtn = Material(
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
            // print({"email": _email, "password": _password});
            try {
              EasyLoading.show();
              final user = await UserService.login(
                  {"email": _email, "password": _password});
              EasyLoading.dismiss();
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('token', user.token);
              Navigator.pushNamed(context, '/todo');
            } catch (e) {
              EasyLoading.dismiss();
              showToast(text: "Login failed!", color: Colors.red);
            }
          }
        },
        child: Text("Login",
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final registerBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        child: Text("Register",
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // final facebookLogin = Material(
    //   elevation: 5.0,
    //   borderRadius: BorderRadius.circular(30.0),
    //   color: HexColor.fromHex('#3578E5'),
    //   child: MaterialButton(
    //     minWidth: MediaQuery.of(context).size.width,
    //     padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    //     onPressed: () async {
    //       Map<String, dynamic> rs = await fbLogin();
    //       if (rs != false) {
    //         print(rs);
    //         showToast(text: "${rs['name']} Login Success");
    //         setTimeout(() => {Navigator.pushNamed(context, '/todo')});
    //       }
    //     },
    //     child: Text("Facebook Login",
    //         style: style.copyWith(
    //             color: Colors.white, fontWeight: FontWeight.bold)),
    //   ),
    // );

    return Scaffold(
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
                SizedBox(
                  height: 155.0,
                  child: Image.network(
                      "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/cute-cat-photos-1593441022.jpg?crop=1.00xw:0.749xh;0,0.154xh&resize=980:*",
                      fit: BoxFit.contain),
                ),
                SizedBox(
                  height: 45.0,
                ),
                emailField,
                SizedBox(
                  height: 25.0,
                ),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                // facebookLogin,
                // SizedBox(
                //   height: 15.0,
                // ),
                loginBtn,
                SizedBox(
                  height: 15.0,
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
