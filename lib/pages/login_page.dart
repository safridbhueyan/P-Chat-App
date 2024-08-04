import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/myTextfild.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  //email and pswrd controllers
  final void Function()? onTap;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pawController = TextEditingController();
  final FocusNode? focusNode;

  LoginPage({
    super.key,
    required this.onTap,
    required this.focusNode,
  });
  //login method
  void login(BuildContext context) async {
//auth service
    final authService = AuthService();

    //try login
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _pawController.text);
    }
    //catch any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
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
              "Welcome back, you've been missed!",
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
            //login button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),
            const SizedBox(
              height: 10,
            ),
            //register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Not a member? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register now",
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
