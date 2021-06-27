import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/widgets/chat/messagebubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  
  Messages(this.uid);
  
  final String uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
        builder:(ctx,futuresnapshot) {
          if (futuresnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream:Firestore.instance.collection('chat').orderBy('createdAt',descending: true).where('send_to',whereIn: [uid,futuresnapshot.data.uid]).where('userid',whereIn: [uid,futuresnapshot.data.uid])
                .snapshots() ,
            builder: (ctx,streamSnapshot){
              print(uid);
              if(streamSnapshot.connectionState ==ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = streamSnapshot.data.documents;
              return ListView.builder(
                  reverse: true,
                  itemCount:documents.length,
                  itemBuilder: (ctx,index)=>


                      MessageBubble(documents[index]['text'],
                      documents[index]['userid']==futuresnapshot.data.uid,
                      documents[index]['username'],
                      documents[index]['image_url'],
                      documents[index]['createdAt'])




              );
            },
          );
        }

    );

  }
}
