import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // final AuthService _auth = AuthService();
  static final _formkey = new GlobalKey<FormState>();
  String _phone = "", _password = "", _username = "", error = "";
  //initially loading is false and all password is obscure
  bool loading = false, obscure1 = true, obscure2 = true;

  signUp() async {
    final response = await http.post(
      Uri.parse('https://call-db-aayu.herokuapp.com/api/appuser/signup'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
          {"phone": _phone, "username": _username, "password": _password}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var serverResponse = response.body;
      if (serverResponse != 5000.toString()) {
        Navigator.pushReplacementNamed(context, "Main");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            //email field
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                //check is email is enabled
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Provide a number';
                  } else
                    return null;
                },
                onChanged: (input) => _phone = input,
                decoration: new InputDecoration(
                    hintText: "Enter Phone",
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: new UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.phone, color: Colors.lightBlue)),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20),
              ),
            ),
            //password field
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                //check is the input length is atlest 6
                validator: (input) {
                  if (input!.length < 6) {
                    return 'Username needs to be atleast 6 characters';
                  } else
                    return null;
                },
                onChanged: (input) => _username = input,
                decoration: new InputDecoration(
                  hintText: "Enter Username",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: new UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.lightBlue),
                ),
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(fontSize: 20),
              ),
            ),
            //password confirm field
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                //checks whether password is long enough and wheter it matches with previous password
                validator: (input) {
                  if (input!.length < 6) {
                    return 'Password needs to be Longer';
                  } else
                    return null;
                },
                onChanged: (input) => _password = input,
                obscureText: obscure2,
                decoration: new InputDecoration(
                    border: new UnderlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "Enter Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.lightBlue),
                    suffixIcon: IconButton(
                        icon: Icon(
                          //shows icon according to state of obscure
                          obscure2 ? Icons.visibility : Icons.visibility_off,
                          color: obscure2 ? Colors.grey : Colors.lightBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            //changes the state of obscure
                            obscure2 ? obscure2 = false : obscure2 = true;
                          });
                        })),
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(15)),
                // ignore: deprecated_member_use
                child: FlatButton(
                    //check the validator and run the create user function if validates also enable loading
                    onPressed: signUp,
                    //check loading and show progress indicator if true else show signup
                    child: loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white))
                        : Text("SignUp",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ))))
          ],
        ),
      ),
    );
  }
}
