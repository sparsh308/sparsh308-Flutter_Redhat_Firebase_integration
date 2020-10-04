import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;

var message1 = "output will appear here";
String x;
void main() {
  runApp(MyApp());
}

final databaseReference = Firestore.instance;
void createRecord(message) async {
  await databaseReference
      .collection("date command")
      .document("result")
      .setData({
    'output': message,
  });
}

web(mycmd) async {
  var message;
  try {
    var url = "http://192.168.84.130/cgi-bin/docker.py?x=${mycmd}";
    var result = await http.get(url);

    message = result.body;

    //return message;
  } catch (_) {
    BotToast.showText(text: "Error in server or Incorrect url");
  }
  createRecord(message);
  //print(mycmd);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Firebase Redhat Integration"),
          ),
          body: mybody()),
    );
  }
}

class mybody extends StatefulWidget {
  @override
  _mybodyState createState() => _mybodyState();
}

class _mybodyState extends State<mybody> {
  String Retrive() {
    setState(() {
      message1 = "loading...";
    });
    databaseReference.collection("date command").snapshots().listen((result) {
      result.documents.forEach((result) {
        print(result.data);

        Future.delayed(const Duration(milliseconds: 4000), () {
          setState(() {
            message1 = result.data.toString();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
                child: FittedBox(
                  child: Image.network(
                      "https://miro.medium.com/max/300/1*R4c8lHBHuH5qyqOtZb3h-w.png"),
                ),
              ),
              FittedBox(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Image.network(
                      'https://developers.redhat.com/blog/wp-content/uploads/2019/07/Red-Hat-Integration-Developers.jpg'),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Linux CLI",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
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
        ),
        RaisedButton(
          color: Colors.blueAccent,
          onPressed: () {
            web(x);

            Retrive();
          },
          child: Text('Execute'),
        ),
        Expanded(
          child: Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black87,
                  border: Border.all(color: Colors.black)),
              child: Column(
                children: [
                  new Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new SingleChildScrollView(
                        scrollDirection: Axis.vertical, //.horizontal
                        child: new Text(
                          message1,
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
