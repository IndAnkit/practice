import 'dart:convert';
import 'dart:ui';

import "package:flutter/material.dart";
import 'package:flutter_app/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

   bool isLoad=true;
   String name;
  String email;
  String pass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
      padding: EdgeInsets.all(16.0),
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors:[
            Colors.redAccent,
            Colors.green
          ])
      ),
      child:Column(
        children: <Widget>[
          SizedBox(height: 40.0,),
          Icon(Icons.person_outline,size: 100.0,color: Colors.white70,),
          SizedBox(height: 40.0,),
          TextField(
            onChanged: (value){
              setState(() {
                email=value;
              });
            },
              decoration: InputDecoration(
              filled: true,
             hintText: "Enter your Email".toLowerCase(),
             fillColor: Colors.white.withOpacity(0.6),
              contentPadding: const EdgeInsets.all(16.0),
              prefixIcon:Container(
               padding: const EdgeInsets.only(top: 8.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0),bottomRight: Radius.circular(10.0),bottomLeft:Radius.circular(30.0)),
                ),
                child: Icon(Icons.person),
              ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none
            )
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            obscureText: true,
            onChanged: (value){
              setState(() {
                pass=value;
              });
            },
            decoration: InputDecoration(
                hintText: "Enter your password".toLowerCase(),
                filled: true,
                fillColor: Colors.white.withOpacity(0.6),
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon:Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0),bottomRight: Radius.circular(10.0),bottomLeft:Radius.circular(30.0)),
                  ),
                  child: Icon(Icons.lock),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none
                )
            ),

          ),

          SizedBox(height: 30.0,),
         SizedBox(
           width: double.infinity,
           child: isLoad?RaisedButton(
             color: Colors.white70,
             padding: EdgeInsets.all(15.0),
             child: Text("LogIn".toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
             onPressed: (){
             if(validate()){
              setState(() {
                isLoad=false;
              });
              getData();
             }else{
               Toast.show("PLease enter valid details", context);
             }

             },
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
           ),
             
           ):Center(child: CircularProgressIndicator(),),
         ),
          Spacer(),
          FlatButton(onPressed:(){}, child:Text("Forgot Password".toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white70),))
        ],
      ),
    ));
  }

  Future<void> getData() async{
    try{
    var response= await http.post("http://139.59.87.150/demo/Shree_Sai_Mall/public/api/user-login",body:{"email":email,"password":pass,"type":"a"}
    );
    var data=json.decode(response.body);
   // print(data['message']);
    if(data['message']=="User login successfully"){
        setState(() {
          name=data['data']['name'];
        });
        await addStringToSF();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));

      //return true;
    }else{
      setState(() {
        isLoad=true;
      });
      Toast.show("Invalid Email and Password", context,duration: Toast.LENGTH_LONG);
      //return false;
    }
    }catch(e){
      print(e);
    }
  }

  bool validate(){
  if(!EmailValidator.validate(email)){
      Toast.show("Invalid Email address".toUpperCase(), context,gravity: Toast.CENTER);
    return false;
  }
  if(pass.length<6){
    Toast.show("Password length must be more than 6 digit", context);
    return false;
  }
  return true;
  }

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email',email);
    prefs.setString('name',name);
    prefs.setString('pass', pass);
    prefs.setBool("isLogin", true);
  }


}
