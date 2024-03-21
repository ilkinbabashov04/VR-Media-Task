import 'package:flutter/material.dart';
import 'package:task_flutter/l10n/app_localizations_en.dart';
import 'package:task_flutter/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _password = '';

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _password = prefs.getString('password') ?? '';
    });
    _usernameController.text = _username;
    _passwordController.text = _password;
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _deleteProfile() async {
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizationsEn.translate('delete_profile')),
          content:
              Text(AppLocalizationsEn.translate('delete_profile_confirmation')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
              child: Text(AppLocalizationsEn.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: Text(
                AppLocalizationsEn.translate('confirm_delete'),
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          AppLocalizationsEn.translate('profile'),
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizationsEn.translate('username'),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText: AppLocalizationsEn.translate('enter_username'),
                hintStyle: TextStyle(color: Colors.grey.shade500),
              ),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizationsEn.translate('password'),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText: AppLocalizationsEn.translate('enter_password'),
                hintStyle: TextStyle(color: Colors.grey.shade500),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center align buttons
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _saveUserData();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Text(
                    AppLocalizationsEn.translate('update'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _logout,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Text(
                    AppLocalizationsEn.translate('logout'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Added space between buttons
            Center(
              child: ElevatedButton(
                onPressed: _deleteProfile,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text(
                  AppLocalizationsEn.translate('delete_profile'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
