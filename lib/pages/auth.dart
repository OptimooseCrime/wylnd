import 'package:flutter/material.dart';
//import '../main.dart';
import 'products.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth1 = FirebaseAuth.instance;
  FirebaseUser user;
  var userInfo;
  Future<FirebaseUser> _handleSignIn(context) async {
    /*final openServiceCalls = Firestore.instance
        .collection('SOAP Notes')
        .where('Status', isEqualTo: 'open')
        .orderBy('DueDate', descending: true)
        .snapshots();*/

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user = (await _auth1.signInWithCredential(credential)).user;

    print("Signed in as " + user.displayName);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsPage(),
        ));
  }

  /*void _signOnStatus() {
      setState(() {
        _handleSignIn();
      });
    }*/
  googleAuth(context) {
    Size size = MediaQuery.of(context).size;
    return new Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Stack(
        children: <Widget>[
          Center(
            child: new Image.network(
              'https://storage.googleapis.com/common-net-cdn/20191210-001603z-f17017dc6/site/static/images/san-leandro-hero.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text('Google Sign In'),
                  onPressed: () => _handleSignIn(context),
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  splashColor: Colors.tealAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/w-bg.png'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _submitForm() async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: _formData['email'], password: _formData['password']))
        .user;
    print(_formData);
    print(user);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => ProductsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    _buildAcceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    new RaisedButton(
                      shape: StadiumBorder(),
                      color: Theme.of(context).accentColor.withOpacity(0.7),
                      textColor: Colors.white,
                      child: Text('LOGIN'),
                      // borderSide: BorderSide(
                      //     color: Colors.deepPurple[50],
                      //     style: BorderStyle.solid,
                      //     width: 1
                      //     ),
                      onPressed: _submitForm,
                    ),
                    FlatButton(
                      onPressed: () => googleAuth(context),
                      child: Text("Google Sign In"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
