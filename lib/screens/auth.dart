import 'package:flutter/material.dart';
import 'package:treasure/services/auth_service.dart';
import 'package:treasure/ui/loading.dart';
class Auth extends StatefulWidget {

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    labelText: "E-mail",
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              !hasError
                  ? SizedBox()
                  : Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(errorMessage)),
              isLoading
                  ? Loading()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text("SignIn"),
                    onPressed: !isLoading ? onSignIn : null,
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    child: Text("Register"),
                    onPressed: !isLoading ? onRegister : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSignIn() async {
    String emailValue = emailController.text;
    String passwordValue = passwordController.text;
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      await authService.signIn(emailValue, passwordValue);
    } catch (error) {
      print("Some error: ${error.code}");
      setState(() {
        hasError = true;
        errorMessage = error.code;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void onRegister() async {
    String emailValue = emailController.text;
    String passwordValue = passwordController.text;
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      await authService.register(emailValue, passwordValue);
    } catch (error) {
      print("Some error: ${error.code}");
      setState(() {
        hasError = true;
        errorMessage = error.code;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
