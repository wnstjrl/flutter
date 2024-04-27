//login_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled22/signup_page.dart';
import 'package:untitled22/home_page.dart'; // MyHomePage를 import합니다.

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _loginMessage = ''; // 로그인 결과 메시지

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _loginMessage = '로그인 성공';
      });

      // 로그인이 성공하면 MyHomePage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loginMessage = '로그인 실패: ${e.code} - ${e.message}';
      });
    }
  }

  void _navigateToSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('로그인'),
            ),
            TextButton(
              onPressed: _navigateToSignUpPage,
              child: Text('회원가입'),
            ),
            SizedBox(height: 10),
            Text(
              _loginMessage,
              style: TextStyle(
                color: _loginMessage.contains('성공') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}