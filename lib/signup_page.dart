//signup_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _signupMessage = ''; // 회원가입 결과 메시지

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _signupMessage = '회원가입 성공';
      });
      // 회원가입 성공 후 예를 들어 다음 페이지로 이동하도록 처리
      Navigator.pop(context); // 회원가입 페이지 닫기
    } on FirebaseAuthException catch (e) {
      setState(() {
        _signupMessage = '회원가입 실패: ${e.code} - ${e.message}';
      });
      // 회원가입 실패 시 사용자에게 알림을 표시할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 페이지'),
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
              onPressed: _signUpWithEmailAndPassword,
              child: Text('회원가입'),
            ),
            SizedBox(height: 10),
            Text(
              _signupMessage,
              style: TextStyle(
                color: _signupMessage.contains('성공') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}