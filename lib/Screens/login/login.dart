import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tumira_cash/Components/background.dart';
import 'package:tumira_cash/Screens/register/register.dart';
import 'package:http/http.dart' as http;
import 'package:tumira_cash/Screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var jsonResponse;
  bool isLoading = false;
  signIn(String email, String password) async {
    String url = "https://tumira-cash-backend.herokuapp.com/auth/login";
    Map body = {"email": email, "password": password};
    String bdy = json.encode(body);
    //print(body);

    var res = await http.Client().post(Uri.parse(url), body: bdy, headers: {
      HttpHeaders.acceptCharsetHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    if (res.statusCode == 200) {
      //print("Response status: ${res.statusCode}");
      Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      String jsonR = jsonResponse['data']['token'];
      //print(jsonResponse);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonResponse['data']['token']);

      //login giriş başarılı!
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen.fromBase64(jsonR)),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 36),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: size.height * 0.033,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "Forget your password?",
                style: TextStyle(fontSize: 12, color: Color(0xFF2661FA)),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  signIn(usernameController.text, passwordController.text);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(88.0),
                      gradient: new LinearGradient(colors: [
                        Color.fromARGB(255, 255, 136, 34),
                        Color.fromARGB(255, 255, 177, 41)
                      ])),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()))
                },
                child: Text(
                  "Don't Have an Account? Sign Up",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
