import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class NewMessage extends StatefulWidget {

  final String recepientuid;
   final String recep_username;

    const NewMessage({this.recepientuid,this.recep_username});




  @override

  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {


  var _enteredmessage = '';
  final _controller = new TextEditingController();


  void _sendmessage() async{
    //print(widget.recep_username);
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userdata = await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text':_enteredmessage,
      'createdAt':Timestamp.now(),
      'userid':user.uid,
      'username':userdata['username'],
      'image_url':userdata['image_url'],
      'send_to':widget.recepientuid

    });
    _controller.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child:TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a Message..'),
                onChanged: (value){
                  setState(() {
                    _enteredmessage=value;
                  });

                },
              ),
          ),
          IconButton(
              icon: Icon(
            Icons.send,
            color: Theme.of(context).primaryColor,
            ),
              onPressed:_enteredmessage.trim().isEmpty? null :_sendmessage,
          )


        ],
      ),
    );
  }
}
