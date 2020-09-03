import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;

var message = "press global";
String x;
void main() {
  runApp(MyApp());
}

final databaseReference = Firestore.instance;
void createRecord() async {
  await databaseReference
      .collection("date command")
      .document("result")
      .setData({
    'date': message,
  });
}

web(mycmd) async {
  try {
    var url = "http://192.168.84.130/cgi-bin/docker.py?x=${mycmd}";
    var result = await http.get(url);
    message = result.body;
    //return message;
  } catch (_) {
    BotToast.showText(text: "Error in server or Incorrect url");
  }
  createRecord();
  return message;

  //print(mycmd);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Firebase Redhat Integration"),
          ),
          body: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      child: Image.network(
                          "https://miro.medium.com/max/300/1*R4c8lHBHuH5qyqOtZb3h-w.png"),
                    ),
                    Container(
                      width: 250,
                      child: Image.network(
                          'https://developers.redhat.com/blog/wp-content/uploads/2019/07/Red-Hat-Integration-Developers.jpg'),
                    )
                  ],
                ),
              ),
              TextField(
                // FocusScope.of(context).requestFocus(new FocusNode());
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                onChanged: (val) {
                  x = val;
                },
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Enter the command Here",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  web(x);
                },
                child: Text('Execute'),
              )
            ],
          )),
    );
  }
}
