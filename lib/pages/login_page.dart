import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/pages/home_page.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:url_shortener_flutter/utils/get_screen_size.dart' as get_screen;
import 'package:url_shortener_flutter/utils/submit_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final BoolVar isSubmitting = Get.put(BoolVar());
  final BoolVar isSuccess = Get.put(BoolVar());
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  Artboard? bearArtboard;
  SMIBool? isChecking, isHandsUp;
  SMITrigger? trigSuccess, numLook, trigFail;
  StateMachineController? stateMachineController;

  @override
  void dispose() {
    super.dispose();
    passwordFocus.removeListener(_onPasswordFocusChange);
    passwordFocus.dispose();
    usernameFocus.removeListener(_onNameFocusChange);
    usernameFocus.dispose();
  }

  void _onNameFocusChange() {
    if (usernameFocus.hasFocus) {
      isChecking!.value = true;
    } else {
      isChecking!.value = false;
    }
  }

  void _onPasswordFocusChange() {
    if (passwordFocus.hasFocus) {
      isHandsUp!.value = true;
    } else {
      isHandsUp!.value = false;
    }
  }

  @override
  void initState() {
    usernameFocus.addListener(_onNameFocusChange);
    passwordFocus.addListener(_onPasswordFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    get_screen.ScreenType screenType = get_screen.getScreenType(context);
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    debugPrint(screenType.toString());
    return Scaffold(
        body: Stack(
      children: [
        Image.asset("assets/background.jpg",
            width: size.width, height: size.height, fit: BoxFit.cover),
        loginForm(
          size,
          formKey,
          context,
          bearArtboard,
          usernameController,
          passwordController,
          isSuccess,
          isSubmitting,
        ),
      ],
    ));
  }

  Widget loginForm(
      Size size,
      GlobalKey<FormState> formKey,
      BuildContext context,
      Artboard? bearArtboard,
      TextEditingController usernameController,
      TextEditingController shortNameController,
      BoolVar isSuccess,
      BoolVar isSubmitting) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(
              top: get_screen.isWeb(context)
                  ? size.height * 0.1
                  : get_screen.isTab(context)
                      ? 200
                      : size.height * 0.15,
              left: get_screen.isWeb(context)
                  ? size.width * 0.35
                  : get_screen.isTab(context)
                      ? 150
                      : 15,
              right: get_screen.isWeb(context)
                  ? size.width * 0.35
                  : get_screen.isTab(context)
                      ? 150
                      : 15,
            ),
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
                          const Text('Login',
                              style: TextStyle(
                                fontSize: 40.0,
                                fontFamily: 'RobotReavers',
                              )),
                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              height: 200,
                              width: 300,
                              child: RiveAnimation.network(
                                  'https://public.rive.app/community/runtime-files/3645-7621-remix-of-login-machine.riv',
                                  fit: BoxFit.contain, onInit: (artboard) {
                                stateMachineController =
                                    StateMachineController.fromArtboard(
                                        artboard, "Login Machine");
                                if (stateMachineController != null) {
                                  artboard
                                      .addController(stateMachineController!);
                                  var inputListener =
                                      stateMachineController!.inputs as List;
                                  isChecking = inputListener.first as SMIBool;
                                  isHandsUp = inputListener[1] as SMIBool;
                                  trigSuccess = inputListener[2] as SMITrigger;
                                  trigFail = inputListener.last as SMITrigger;
                                }
                              }),
                            ),
                          ),
                          TextFormField(
                            focusNode: usernameFocus,
                            controller: usernameController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black54, width: 2.0),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black45),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors
                                    .black54, // Set the color you want here
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
                            focusNode: passwordFocus,
                            controller: shortNameController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black54, width: 2.0),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black45),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.black54,
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
                          SubmitButton(
                            icon: const Icon(Icons.login, color: Colors.white),
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                trigFail!.fire();
                                return;
                              } else {
                                isSubmitting.val = true; // }
                                await Auth()
                                    .loginRequest(usernameController.text,
                                        passwordController.text)
                                    .then((value) {
                                  if (value != null) {
                                    trigSuccess!.fire();
                                    isSuccess.val = true;
                                    isSubmitting.val = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator
                                          .pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(user: value)),
                                              (route) =>
                                                  false).then((value) => {
                                            usernameController.clear(),
                                            passwordController.clear(),
                                            isSuccess.val = false,
                                          });
                                    });
                                  } else {
                                    trigFail!.fire();
                                    isSuccess.val = false;
                                  }
                                });
                              }
                            },
                            isSuccess: isSuccess,
                            textSuccess: 'Login Success',
                            textFail: 'Login Fail',
                            text: 'Sign In',
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: 'Don\'t have an account? ',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
