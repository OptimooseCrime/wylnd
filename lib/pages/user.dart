import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';


class UserAccount extends StatefulWidget {
  FirebaseUser user;
  UserAccount({this.user});
    @override
  _UserAccountState createState() => _UserAccountState();
}
class _UserAccountState extends State<UserAccount> { 
  
  @override
  Widget build(BuildContext context) {
  print(widget.user);

    return Scaffold(
      appBar: AppBar(
        title: Text("Account "+widget.user.email),
      ),
      body: Column(
        children: <Widget>[
        Text('User Data'),
        Text('Your Email: '+widget.user.email),
        Text('Sign In With: '+widget.user.providerId)
      ]
      )
    );
  }
}
