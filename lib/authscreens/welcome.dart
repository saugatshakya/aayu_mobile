import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://images.pexels.com/photos/7615409/pexels-photo-7615409.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                fit: BoxFit.cover)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 240,
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(width: 250, child: Image.asset("assets/aayu16.png")),
                Container(
                  width: 200,
                  height: 2,
                  color: Colors.lightBlue,
                )
              ])),
          SizedBox(height: MediaQuery.of(context).size.height * 0.5),
          Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width - 30,
              // ignore: deprecated_member_use
              child: TextButton(
                  onPressed: () {
                    //go to login screen
                    Navigator.pushNamed(context, "Login");
                  },
                  child: Text("Login / SignUp",
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Colors.white)))),
          SizedBox(height: 10),
          // ignore: deprecated_member_use
          TextButton(
            onPressed: () {
              //go directly to list of ambulance
              Navigator.popAndPushNamed(context, "Main");
            },
            child: Text("Sign In Anonomously",
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none)),
          )
        ]));
  }
}
