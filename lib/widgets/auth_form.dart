import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chat_app/widgets/picker/dummy2.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthForm extends StatefulWidget {

  AuthForm(this.submitfn,this._isloading,this.submitgoogle);

  final bool _isloading;

  final void Function(
      bool isgoogle
      ) submitgoogle;





  final void Function(
      String email,
      String username,
      String password,
      File userimage,
      bool islogin,
      BuildContext ctx
      ) submitfn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  String google = 'google';

  final _formKey = GlobalKey<FormState>();
  var _isgoogle= false;
  var _islogin = true;
  String userEmail = '';
  String username = '';
  String password = '';
  File _userimagefile;

  void imagepick(File image){
    _userimagefile = image;
  }
  void _trygsignin(){
   widget.submitgoogle(_isgoogle);
  }
  void _trysubmit(){
   final isvalid = _formKey.currentState.validate();
   FocusScope.of(context).unfocus();

   if(_userimagefile == null && !_islogin){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       content: Text('please upload an image'),
       backgroundColor: Theme.of(context).errorColor,),);

     return;
   }


   if(isvalid)
     _formKey.currentState.save();

   widget.submitfn(
       userEmail.trim(),
       username.trim(),
       password.trim(),
       _userimagefile,
       _islogin,
     context
   );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               if(!_islogin)
               Imagepicker(imagepick),
                TextFormField(
                  key: ValueKey('email'),   // for clearing data when switching

                  validator: (value){
                    if(value.isEmpty || !value.contains('@'))
                      return 'please enter a valid email';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email address'
                  ),
                  onSaved: (value){
                    userEmail = value;
                  },
                ),
                if(!_islogin)
                TextFormField(
                  key: ValueKey('username'),
                  validator: (value){
                    if(value.isEmpty || value.length<4)
                      return 'minimum 4 charectors required ';
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Username',

                  ),
                  onSaved: (value){
                    username = value;
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),   // for clearing data when switching
                  validator: (value){
                    if(value.isEmpty || value.length<7)
                      return 'password must contains minimum 7 charectors ';
                    return null;
                  },
                 obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password'
                  ),
                  onSaved: (value){
                    password = value;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                if(widget._isloading)
                  CircularProgressIndicator(),
                if(!widget._isloading)
                   RaisedButton(
                   child: Text(_islogin?'login':'Sign Up'),
                    onPressed: (){
                    _trysubmit();
                    }
                    ),

                if(!widget._isloading)
                  FlatButton(onPressed: (){
                  setState(() {
                    _islogin = !_islogin;
                  });

                },
                child: Text(_islogin?'create new account':'i already have an account'),
                textColor: Theme.of(context).primaryColor,),
                if(!widget._isloading)
              /*  FlatButton.icon(onPressed:(){
                  setState(() {
                   _isgoogle=true;
                  });
                  _trygsignin();
                },
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.copy),
                    label: Text('google sign in')),

               */
                SignInButton(
                    Buttons.Google,
                    text: "sign in with google",

                    onPressed:(){
                      setState(() {
                        _isgoogle=true;
                      });
                      _trygsignin();
                    } ),
              /*  SignInButton(
                  Buttons.Facebook,
                  mini: true,
                  onPressed: () {},
                )

               */
              ],
            ),
          ),
        ),
      ),

      );

  }
}
