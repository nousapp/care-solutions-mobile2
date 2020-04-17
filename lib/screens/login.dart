import 'package:flutter/material.dart';
import 'scanner.dart';
import 'package:care_solutions/util/context.dart';
import 'package:care_solutions/util/session.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _client = "Royal Bellingham";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_client), 
        backgroundColor: Color(0xFF293D50),
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  LoginBodyState createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginKey = GlobalKey<FormState>();
  String _error = "";

  void _login() async {
    setState(() {
      _error = "";
    });
    if (_loginKey.currentState.validate()) {
      //Authenticate here
      var users = await User.getAll();
      var loginuser = users
          .where((user) =>
              user.userid == _usernameController.text &&
              user.password == _passwordController.text)
          .toList();
      if (loginuser.length > 0) {
        Session.setKey('role', loginuser[0].role);
        Session.setKey('user', loginuser[0].userid);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Scanner()),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _error = "User not found";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/wallpaper.jpg'),
              SizedBox(height: 50),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
                controller: _usernameController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                    ),
                    hintText: 'Enter Username'),
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                    ),
                    hintText: 'Enter Password'),
              ),
              SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () => _login(),
                    color: Color(0xFF293D50),
                    textColor: Colors.white,
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  _error,
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
