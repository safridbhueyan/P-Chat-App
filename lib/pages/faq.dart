import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("F A Q "),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50.0), // Consistent padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(25.0), // Consistent margin
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'This app is created by ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'Safrid Bhuyian',
                      style: const TextStyle(
                          color:
                              Color.fromARGB(255, 88, 187, 233), // Link color
                          decoration: TextDecoration.underline,
                          fontSize: 20 // Underline for visual cue
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri url = Uri.parse(
                              'https://www.linkedin.com/in/safridbhueyan'); // Replace with actual URL if needed
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            // Handle error, e.g., show a snackbar or message
                            print('Could not launch $url');
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
