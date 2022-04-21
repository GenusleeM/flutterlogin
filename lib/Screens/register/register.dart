import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tumira_cash/Components/background.dart';
import 'package:tumira_cash/Screens/home/home.dart';
import 'package:tumira_cash/Screens/login/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:tumira_cash/Components/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterScreen createState() => RegisterScreen();
}

class RegisterScreen extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController id_numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  var jsonResponse;
  bool isLoading = false;
  signUp(String email, String password, String lastname,String firstname, 
      String phone, String id_number, String address, String role) async {
    String url = "https://tumira-backend.herokuapp.com/auth/register";
    Map body = {
      "email": email,
      "password": password,
      "lastname": lastname,
      "firstname": firstname,
      "phone": phone,
      "id_number": id_number,
      "address": address,
      "role": role
    };
    String bdy = json.encode(body);
    // var res = await http.Client().post(Uri.parse(url), body: body);
    var res = await http.Client().post(Uri.parse(url), body: bdy, headers: {
      HttpHeaders.acceptCharsetHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    print(bdy);
    if (res.statusCode == 200) {
      //jsonResponse = json.decode(res.body);
      var jsonResponse = res.body;
      print(res.body);
      if (jsonResponse.toString().length <= 5) {
        setState(() {
          isLoading = false;
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonResponse);
      // kayıt başarılı!

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomeScreen.fromBase64(jsonResponse)),
          (Route<dynamic> route) => false);

      /*showDialog(
        context: context,
        builder: (_) => PopUpDialog(
          title: "Registration Successfull!",
          content: "Please login with your credentials!",
          page: LoginPage(),
        ),
      );*/
    } else {
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => PopUpDialog(
          title: "Registration Error",
          content: "Email / password is wrong!",
          page: RegisterPage(),
        ),
        //barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.09,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Register",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 36),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
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
            SizedBox(height: size.height * 0.01),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: lastnameController,
                decoration: InputDecoration(labelText: "Last Name"),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: firstnameController,
                decoration: InputDecoration(labelText: "First Name"),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: id_numberController,
                decoration: InputDecoration(labelText: "ID Number"),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Address"),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: roleController,
                decoration: InputDecoration(labelText: "Role"),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed:
                    emailController.text == "" || passwordController.text == ""
                        ? null
                        : () {
                            setState(() {
                              isLoading = true;
                            });
                            signUp(
                                emailController.text,
                                passwordController.text,
                                lastnameController.text,
                                firstnameController.text,
                                phoneController.text,
                                id_numberController.text,
                                addressController.text,
                                roleController.text,);
                          },

                //shape: RoundedRectangleBorder(
                //    borderRadius: BorderRadius.circular(80.0)),
                //textColor: Colors.white,
                //padding: const EdgeInsets.all(0),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0)),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(colors: [
                        Color.fromARGB(255, 255, 136, 34),
                        Color.fromARGB(255, 255, 177, 41)
                      ])),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                      MaterialPageRoute(builder: (context) => LoginPage()))
                },
                child: Text(
                  "Already Have an Account? Login",
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
