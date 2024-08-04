import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/myTextfild.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  void Function()? onTap;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pawController = TextEditingController();
  final TextEditingController _confirmpawController = TextEditingController();
  final FocusNode? focusNode;

  RegisterPage({super.key, required this.onTap, required this.focusNode});

  void register(BuildContext context) {
    // get auth service

    final _auth = AuthService();

//passwords match create user
    if (_pawController.text == _confirmpawController.text) {
      try {
        _auth.signUpWithEmailPassword(
            _emailController.text, _pawController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //if password dont match show an error

    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password dont match! "),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo
            Icon(
              Icons.message_rounded,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 50,
            ),
            //welcome back massg
            Text(
              "Lets create an account for you!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            //email textfield
            Mytextfild(
              hintext: "Email",
              obscureText: false,
              controller: _emailController,
              focusNode: focusNode,
            ),

            const SizedBox(
              height: 10,
            ),

            //pw textfield
            Mytextfild(
              hintext: "Password",
              obscureText: true,
              controller: _pawController,
              focusNode: focusNode,
            ),
            const SizedBox(
              height: 10,
            ),
            Mytextfild(
              hintext: "Confirm password",
              obscureText: true,
              controller: _confirmpawController,
              focusNode: focusNode,
            ),
            const SizedBox(
              height: 10,
            ),
            //login button
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 10,
            ),
            //register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Login now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
