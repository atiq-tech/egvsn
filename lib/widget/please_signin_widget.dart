import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/widget/primary_button.dart';
import 'package:flutter/material.dart';



class PleaseSignInWidget extends StatelessWidget {
  const PleaseSignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text(
              //   "Sign in please",
              //   style: TextStyle(color: redColor),
              // ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Sign In Please',
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.authenticationScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
