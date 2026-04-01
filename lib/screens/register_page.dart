import 'package:flutter/material.dart';
import '../data/fake_db.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String message = "";

  void register() {
    String user = userController.text;
    String pass = passController.text;

    if (user.isEmpty || pass.isEmpty) {
      setState(() {
        message = "Không được để trống!";
      });
      return;
    }

    if (users.containsKey(user)) {
      setState(() {
        message = "Tài khoản đã tồn tại!";
      });
    } else {
      users[user] = pass;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text("Đăng ký")),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}