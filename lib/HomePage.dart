import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var listPost;
  var listPhoto;
  Map _userData;
  String name;
  String email,pass;
  @override
  void initState() {
   getDataToSF();
   getPhotoData();
   getPostData();

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
        child: Column(
          children: <Widget>[
        Container(
          height:250.0,
          width: double.infinity,
          color: Colors.grey[900],

            child:(name!=null)?Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Icon(Icons.person,size: 100.0,color: Colors.white,),
                SizedBox(height: 10.0,),
                Text(name,style: TextStyle(fontSize: 20.0,color: Colors.white),),
                SizedBox(height: 10.0,),
                Text(email,style: TextStyle(fontSize: 20.0,color: Colors.white),),
              ],
            ):Center(child: CircularProgressIndicator(),),
          ),


        SizedBox(height:10.0),

        Padding(padding:EdgeInsets.symmetric(vertical: 10.0),
          child: InkWell(
            onTap: (){
              addStringToSF();
              Toast.show("Logout Successfully", context,duration:3);

             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LogIn()));
            },
            child: ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text("LogOut"),
            ),
          ),
          ),



        ]),
        ),
          appBar: AppBar(
           bottom: TabBar(
               indicatorColor: Colors.redAccent,
               labelColor: Colors.redAccent,
               unselectedLabelColor: Colors.white70,
               tabs:[
             Tab(icon: Icon(Icons.image),text:"Photos",),
             Tab(icon: Icon(Icons.local_post_office),text:"Posts",)
           ]),
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: Text("Home Page".toUpperCase()),),
        body: TabBarView(children:[
          photoList(),
          postList()
        ]),
      ),
    );
  }

  getDataToSF()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
     email= pref.getString("email");
     name= pref.getString("name")??"ankit";
      pass=pref.getString('pass');
    });
    getData();
  }

  Future<void> getData() async{
    var response= await http.post("http://139.59.87.150/demo/Shree_Sai_Mall/public/api/user-login",body:{"email":email,"password":pass,"type":"a"}
    );
    var data=json.decode(response.body);
    //print(data['message']);
    if(data['message']=="User login successfully"){
      setState(() {
        _userData=data['data'];
      });
     // print(_userData);
      //return true;
    }
  }

  getPhotoData()async{
    var response= await http.get("https://jsonplaceholder.typicode.com/photos");
    var data=jsonDecode(response.body);
    setState(() {
      listPhoto=data;
    });
   // print(listPhoto);
  }
  getPostData()async{
    var response= await http.get("https://jsonplaceholder.typicode.com/posts");
    var data=jsonDecode(response.body);
    setState(() {
      listPost=data;
    });
   // print(listPost[1]);
  }
  
  Widget photoList(){
    if(listPhoto!=null){
    return ListView.builder(
        itemCount: listPhoto.length,
        itemBuilder:(context,i){
          return Card(
            child: Container(
              height: 160.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Expanded(child:InkWell(
                      onTap: (){
                        var alertBox=AlertDialog(

                          content: Container(
                              height: 300.0,
                              padding: EdgeInsets.all(0.1),
                              margin: EdgeInsets.all(0.1),
                              child: Image.network(listPhoto[i]['url'],fit: BoxFit.fill,)),
                        );
                        showDialog(context:context,builder: (context)=>alertBox);
                      },
                      child: Image.network(listPhoto[i]['thumbnailUrl']))),
                   Expanded(
                     child: Container(
                         padding: EdgeInsets.all(5.0),
                         child: Text(listPhoto[i]['title'],textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),)),
                   ),
                ],
              ),
            ),
          );
        }
    
    );
  }else{
    return Center(child: CircularProgressIndicator(),);
    }
  }

  Widget postList(){
    if(listPost!=null){
      return ListView.builder(
          itemCount: listPost.length,
          itemBuilder:(context,i){
            return Card(
              elevation: 20.0,
              child: InkWell(
                onTap: (){
                  var alertBox=AlertDialog(
                actions: <Widget>[
                  Container(
                      height: 300.0,
                      padding: EdgeInsets.all(0.1),
                      margin: EdgeInsets.all(0.1),
                      child: Image.network(listPhoto[i]['url'],fit: BoxFit.fill,)),

                  Text(listPhoto[i]['title'],textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
                ],
              );
              showDialog(context:context,builder: (context)=>alertBox);
            },
                child: Container(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(listPost[0]['title'],style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(listPost[0]['body']),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

      );
    }else{
      return Center(child: CircularProgressIndicator(),);
    }
  }

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email',"");
    prefs.setString('name',"");
    prefs.setString('pass',"");
    prefs.setBool("isLogin",false);
  }
}
