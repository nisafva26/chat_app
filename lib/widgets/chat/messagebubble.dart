import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message,this.isme,this.username,this.imageurl,this.time);

  final String message ;
  final bool isme;
  final String username;
  final String imageurl;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ Row(
        mainAxisAlignment: isme?MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          Container(

            width: 140.0,
            decoration: BoxDecoration(
              color: isme?Colors.grey[300]:Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                topRight: isme?Radius.circular(0):Radius.circular(15.0),
                  topLeft: !isme?Radius.circular(0):Radius.circular(15.0)


              )

            ),
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 15.0),
            margin: EdgeInsets.symmetric(vertical: 15.0,horizontal: 5.0),
            child: Column(
              crossAxisAlignment: isme?CrossAxisAlignment.end:CrossAxisAlignment.start,
              children: [
                 Text(username,style:
                      TextStyle(
                        color: isme?Colors.black:Theme.of(context).accentTextTheme.title.color,
                        fontWeight: FontWeight.bold),
                 ),




                SizedBox(height: 5.0,),

                Text(message,style: TextStyle(
                  fontSize: 17.0,
                  color: isme?Colors.black:Theme.of(context).accentTextTheme.title.color
                ),),
             //   Text(time.toDate().toString())
              ],

          ),
          ),
        ],
      ),
        Positioned(
          top: 10.0,
           left: isme? null :120.0,
            right:isme?120:null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageurl),
            ))
    ]
    );
  }
}
