import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flutter/components/my_button.dart';
import 'package:task_flutter/components/my_textField.dart';
import 'package:task_flutter/home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (loggedIn) {
      navigateToHomePage();
    }
  }

  void signUserIn() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String apiUrl = 'https://fakestoreapi.com/auth/login';
    var response = await http.post(Uri.parse(apiUrl), body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      String token = response.body;
      await cacheToken(token);
      navigateToHomePage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to login. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> cacheToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool('isLoggedIn', true);
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Welcome back you\'ve been missed ',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obsucureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obsucureText: true,
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: isLoggedIn ? navigateToHomePage : signUserIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
