import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'file:///D:/flutter_projects/chat_app/lib/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/newmessage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatelessWidget {

  ChatScreen(this.uid,this.username);
  final String uid;
  final String username;
  final _auth = FirebaseAuth.instance;
  final googlesignin = GoogleSignIn();

  void singout ()async{
    FirebaseUser user = await _auth.currentUser();

    if(user.providerData[1].providerId =='google.com'){
      await googlesignin.disconnect();
    }

    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert,color: Theme.of(context).primaryIconTheme.color),
              items: [
                DropdownMenuItem(child:
                 Container(child:
                      Row(children: [
                        Icon(Icons.exit_to_app,color: Colors.black,),
                        SizedBox(width: 8.0,),
                        Text('logout')
                     ],
                    ),
                 ),
                  value: 'logout',
                ),

              ],
             onChanged:(itemidentifier){
              if(itemidentifier=='logout')
                singout();
              //  FirebaseUser user = await _auth.currentUser();

               // FirebaseAuth.instance.signOut();


    }
              )

        ],
      ),
      body:Container(
        child: Column(
          children: [
            Expanded(child: Messages(uid),
            ),
            NewMessage(recepientuid: uid,recep_username: username,)
            //NewMessage()
          ],
        ),
      )
      ,



    );
  }
}
