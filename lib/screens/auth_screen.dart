import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;

  final googlesignin = GoogleSignIn();

  var _isloading = false;







  void _googlesignin(bool isgoogle) async{
    try{
      if(isgoogle){
        setState(() {
          _isloading=true;
        });
        GoogleSignInAccount googleaccount = await googlesignin.signIn();
        if(googleaccount!=null){
          GoogleSignInAuthentication googleauth = await googleaccount.authentication;
          AuthCredential credential = GoogleAuthProvider.getCredential(
              idToken: googleauth.idToken, accessToken: googleauth.accessToken);
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = await _auth.currentUser();

          await  Firestore.instance.collection('users').
          document(result.user.uid).
          setData(
            ({'username':result.user.displayName,'email':result.user.email,'image_url':result.user.photoUrl}),);
          print(user);
        }

      }
    }catch(err){
      print(err);
    }
  }



  void _submitAuthForm(
      String email,
      String username,
      String password,
      File userimage,
      bool islogin,
      BuildContext ctx
      ) async {
    try {
      setState(() {
        _isloading=true;
      });
      AuthResult authresult;
      if (islogin)
        authresult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      else{
        authresult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref =  FirebaseStorage.instance.ref().
                                child('user_image').
                                child(authresult.user.uid + '.jpg');
        await ref.putFile(userimage).onComplete;

        final url = await ref.getDownloadURL();

        // storing extra data
       await  Firestore.instance.collection('users').
        document(authresult.user.uid).
        setData(
         ({'username':username,'email':email,'image_url':url}),);    // adding extra user data
      }
    }on PlatformException catch(err){

      setState(() {
        _isloading=false;
      });

      var message = 'an error occured ';

      if(err.message!=null)
        message = err.message;

      Scaffold.of(ctx).showSnackBar(SnackBar
        (content: Text(message),
      backgroundColor: Theme.of(ctx).errorColor,
      ),
      );
    }
    catch(err){
      setState(() {
        _isloading=false;
      });
      print(err);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm,_isloading,_googlesignin) ,
    );
  }
}
