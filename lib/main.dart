import 'package:flutter/material.dart';
import 'screens/login.dart';


//void main() => runApp(Login());
void main() {
  runApp(MaterialApp(
      title: 'Care Solutions App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Login()));
}
