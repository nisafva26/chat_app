import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Users extends StatelessWidget {

  final _auth = FirebaseAuth.instance;
  final googlesignin = GoogleSignIn();

  void singout() async {
    FirebaseUser user = await _auth.currentUser();

    if (user.providerData[1].providerId == 'google.com') {
      await googlesignin.disconnect();
    }


    FirebaseAuth.instance.signOut();
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Available Users'),
            actions: [
              DropdownButton(
                  icon: Icon(Icons.more_vert, color: Theme
                      .of(context)
                      .primaryIconTheme
                      .color),
                  items: [
                    DropdownMenuItem(child:
                    Container(child:
                    Row(children: [
                      Icon(Icons.exit_to_app, color: Colors.black,),
                      SizedBox(width: 8.0,),
                      Text('logout')
                    ],
                    ),
                    ),
                      value: 'logout',
                    ),

                  ],
                  onChanged: (itemidentifier) {
                    if (itemidentifier == 'logout')
                      singout();
                    //  FirebaseUser user = await _auth.currentUser();

                    // FirebaseAuth.instance.signOut();


                  }
              )

            ]
        ),
        body: Column(
          children: [


            Expanded(
              child: PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
                // listview and gridview
                itemBuilder: (index, context, documentSnapshot) =>
                    GestureDetector(

                      child: ListTile(

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                ChatScreen(documentSnapshot.documentID,
                                    documentSnapshot.data['username']),),);
                        },
                        leading: CircleAvatar(

                          backgroundImage: NetworkImage(
                              documentSnapshot.data['image_url']),


                          //backgroundColor: Colors.black,
                        ),
                        title: Text(documentSnapshot.data['username']),


                      ),
                    ),
                // orderBy is compulsary to enable pagination
                query: Firestore.instance.collection('users').orderBy(
                    'username')
                //isLive: true // to fetch real-time data
              ),
            ),
          ],
        ),
      );
    }
  }



