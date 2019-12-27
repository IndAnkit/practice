import 'package:flutter/material.dart';
import 'package:flutter_app/HomePage.dart';
import 'package:flutter_app/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLogIn=false;
  bool isData=true;
   @override
  void initState() {

     getBoolValuesSF();
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
       // primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        cursorColor: Colors.red
      ),
      home:isData?Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator())):isLogIn?HomePage():LogIn(),
    );
  }

   getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    setState(() {
      isLogIn = prefs.getBool('isLogin') ?? false;
      isData=false;
    });
   // return isLogIn?LogIn():HomePage();
  }
}
