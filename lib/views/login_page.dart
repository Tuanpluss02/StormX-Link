import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rive/rive.dart';
import 'package:url_shortener_flutter/common/constant.dart';
import 'package:url_shortener_flutter/common/enums.dart';
import 'package:url_shortener_flutter/components/submit_button.dart';
import 'package:url_shortener_flutter/utils/validate_extension.dart';

import '../blocs/auth/auth_bloc.dart';
import '../components/custom_snackbar.dart';
import '../components/custom_text_field.dart';
import '../components/rive_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  Artboard? bearArtboard;
  SMIBool? isChecking, isHandsUp;
  SMITrigger? trigSuccess, numLook, trigFail;
  StateMachineController? stateMachineController;

  Map<AuthStatus, ButtonState> buttonStateMap = {
    AuthStatus.loading: ButtonState.loading,
    AuthStatus.authenticated: ButtonState.success,
    AuthStatus.unauthenticated: ButtonState.fail,
    AuthStatus.failure: ButtonState.fail,
  };

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
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.authenticated) {
          trigSuccess!.fire();
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamed(context, '/home');
          });
        } else if (state.authStatus == AuthStatus.unauthenticated) {
          showMaterialBanner(
              context: context,
              title: 'Login Failed',
              message: 'Username or Password is incorrect',
              contentType: ContentType.failure);
          trigFail!.fire();
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(bgImage), fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: size.height * 0.1,
                            left: size.width * 0.35,
                            right: size.width * 0.35),
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
                                margin: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const Text('Login',
                                        style: TextStyle(
                                          fontSize: 40.0,
                                          fontFamily: 'RobotReavers',
                                        )),
                                    const SizedBox(height: 30),
                                    bearAnimation(onInit: (artboard) {
                                      stateMachineController =
                                          StateMachineController.fromArtboard(
                                              artboard, "Login Machine");
                                      if (stateMachineController != null) {
                                        artboard.addController(
                                            stateMachineController!);
                                        var inputListener =
                                            stateMachineController!.inputs
                                                as List;
                                        isChecking =
                                            inputListener.first as SMIBool;
                                        isHandsUp = inputListener[1] as SMIBool;
                                        trigSuccess =
                                            inputListener[2] as SMITrigger;
                                        trigFail =
                                            inputListener.last as SMITrigger;
                                      }
                                    }),
                                    customTextFormField(
                                        obscureText: false,
                                        focusNode: usernameFocus,
                                        controller: usernameController,
                                        labelText: 'Username',
                                        validator: ValidationBuilder()
                                            .minLength(4)
                                            .maxLength(20)
                                            .username()
                                            .build()),
                                    const SizedBox(height: 20),
                                    customTextFormField(
                                        obscureText: true,
                                        focusNode: passwordFocus,
                                        controller: passwordController,
                                        labelText: 'Password',
                                        validator: ValidationBuilder()
                                            .minLength(8)
                                            .maxLength(20)
                                            .password()
                                            .build()),
                                    const SizedBox(height: 20),
                                    submitButton(
                                        text: "Login",
                                        onPressed: () => context
                                            .read<AuthBloc>()
                                            .add(LoginEvent(
                                                username:
                                                    usernameController.text,
                                                password:
                                                    passwordController.text)),
                                        state:
                                            buttonStateMap[state.authStatus]!)
                                  ],
                                ),
                              )),
                        ))
                  ],
                )));
      },
    );
  }
}
