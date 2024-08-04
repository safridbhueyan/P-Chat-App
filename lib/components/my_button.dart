import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  void Function()? onTap;
  final String text;

  MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
