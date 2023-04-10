import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/models/user.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:url_shortener_flutter/utils/submit_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  final BoolVar isSubmitting = Get.put(BoolVar());
  final BoolVar isSuccess = Get.put(BoolVar());
  late User user = User();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Stack(
      children: [
        Image.asset("assets/background.jpg",
            width: size.width, height: size.height, fit: BoxFit.cover),
        signupForm(
          size,
          formKey,
          context,
          usernameController,
          passwordController,
          reEnterPasswordController,
          isSuccess,
          isSubmitting,
        ),
      ],
    ));
  }

  Widget signupForm(
      Size size,
      GlobalKey<FormState> formKey,
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController reEnterPasswordController,
      BoolVar isSuccess,
      BoolVar isSubmitting) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.35, vertical: size.height * 0.17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            // color: Colors.white.withOpacity(0.1),
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Sign Up',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontFamily: 'RobotReavers',
                        )),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black54, width: 2.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black45),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54, // Set the color you want here
                        ),
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black54, width: 2.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black45),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54, // Set the color you want here
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: reEnterPasswordController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black54, width: 2.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black45),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54, // Set the color you want here
                        ),
                        labelText: 'Re-enter password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        if (reEnterPasswordController.text !=
                            passwordController.text) {
                          return 'Password not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SubmitButton(
                      icon: const Icon(
                        Icons.key,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          isSubmitting.val = true;
                          // isSuccess.val = await Auth().signupRequest(
                          //   usernameController.text,
                          //   passwordController.text,
                          // );
                          await Auth()
                              .signupRequest(
                            usernameController.text,
                            passwordController.text,
                          )
                              .then((value) {
                            if (value != null) {
                              user = value;
                              isSuccess.val = true;
                            } else {
                              isSuccess.val = false;
                            }
                          });
                        }
                      },
                      isSuccess: isSuccess,
                      isSubmitting: isSubmitting,
                      textSuccess: 'Sign Up Success',
                      textFail: 'Sign Up Failed',
                      navigator: () {
                        Navigator.pushNamed(
                          context,
                          '/shorten',
                        );
                      },
                      text: 'Sign Up',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
