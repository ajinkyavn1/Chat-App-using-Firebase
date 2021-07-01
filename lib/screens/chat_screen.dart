
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth=FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  String messege;
  User loggedin;

  getCurruntUser()async{
    final user=await _auth.currentUser;
    if(user!=null)
    {
      loggedin=user;
      print(loggedin.email);
    }

  }
  getMesseges()async{
    final messeges=await _firestore.collection("Messeges").get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((messeges) {
        print(messeges.data());
      });
    });
  }
  @override
  void initState() {
    super.initState();
    getCurruntUser();
    getMesseges();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: _firestore.collection("Messeges").snapshots(),
              builder: (context,shapshot){
                if(shapshot.hasData) {
                  final messeges = shapshot.data.documents;
                    List<Text> messegeWidget = [];
                    for (var messege in messeges) {
                      final MessegeText=messege.data['text'];
                      final Sender=messege.data['sender'];
                      print(MessegeText);
                      print(Sender);
                      }
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messege=value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      print(messege);
                      _firestore.collection("Messeges").add({
                        'text':messege,
                        'sender':loggedin.email
                      });
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
