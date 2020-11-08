import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video/homepage.dart';

String name, email, photoUrl;

class GoogleAuthentication extends StatefulWidget {
  @override
  _GoogleAuthenticationState createState() => _GoogleAuthenticationState();
}

class _GoogleAuthenticationState extends State<GoogleAuthentication> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> googleSignIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(authCredential);
    final User user = userCredential.user;
    assert(user.displayName != null);
    assert(user.email != null);
    assert(user.photoURL != null);

    setState(() {
      name = user.displayName;
      email = user.email;
      photoUrl = user.photoURL;
    });

    final User currentUser = _firebaseAuth.currentUser;
    assert(currentUser.uid == user.uid);
    return 'Logged In';
  }

  @override
  Widget build(BuildContext context) {
    final _index = 0;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: IndexedStack(index: _index, children: [
        Container(
          height: _height,
          width: _width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _height / 4,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: FlutterLogo(
                  size: 200,
                  colors: Colors.deepPurple,
                ),
              ),
              SizedBox(
                height: _height / 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: _width / 10,
                  ),
                  Text(
                    "Continue With",
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
              SizedBox(
                height: _height / 35,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(_width / 10, 0, _width / 10, 0),
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        onPressed: () => googleSignIn().whenComplete(() {               // Google Authetication Call
                          Navigator.pushReplacement(                                      
                              context,                                     
                              MaterialPageRoute(                                        // Directed to Video Player
                                  builder: (context) => Videoplayer()));
                        }),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image(
                                  image: AssetImage("assets/google_logo.png"),
                                  height: 35.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
