import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rive/rive.dart';
import 'package:url_shortener_flutter/common/constant.dart';
import 'package:url_shortener_flutter/common/enums.dart';
import 'package:url_shortener_flutter/components/submit_button.dart';

import '../blocs/auth/auth_bloc.dart';
import '../components/custom_snackbar.dart';
import '../components/custom_text_field.dart';
import '../components/rive_animation.dart';
import '../routes/route_name.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  Artboard? bearArtboard;
  SMIBool? isChecking, isHandsUp;
  SMITrigger? trigSuccess, numLook, trigFail;
  StateMachineController? stateMachineController;

  Map<AuthStatus, ButtonState> buttonStateMap = {
    AuthStatus.loading: ButtonState.loading,
    AuthStatus.success: ButtonState.success,
    AuthStatus.initial: ButtonState.idle,
    AuthStatus.failure: ButtonState.fail,
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint("state: ${state.authStatus}");
        if (state.authStatus == AuthStatus.success) {
          trigSuccess!.fire();
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.homePage, (route) => false);
          });
          context.read<AuthBloc>().add(
              const ChangeAppStatusEvent(appStatus: AppStatus.authenticated));
        } else if (state.authStatus == AuthStatus.failure) {
          trigFail!.fire();
          showSnackBar(
              context: context,
              title: 'Login Failed',
              message: 'Username or Password is invalid',
              contentType: ContentType.failure);
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
                                child: Form(
                                  key: formKey,
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
                                          isHandsUp =
                                              inputListener[1] as SMIBool;
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
                                          validator: (value) {
                                            final regex = RegExp(
                                                r'^(?!.*[-_.]{2})[A-Za-z0-9]+[A-Za-z0-9_.\-]*[A-Za-z0-9]$');
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Username is required';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Username must be 4-20 characters long and can only contain letters, numbers, underscores, periods and hyphens.';
                                            }
                                            return null;
                                          }),
                                      const SizedBox(height: 20),
                                      customTextFormField(
                                          obscureText: true,
                                          focusNode: passwordFocus,
                                          controller: passwordController,
                                          labelText: 'Password',
                                          validator: (value) {
                                            final regex = RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Password is required';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Password must be 8 characters long and contain at least one uppercase letter, one lowercase letter and one number.';
                                            }
                                            return null;
                                          }),
                                      const SizedBox(height: 20),
                                      submitButton(
                                          text: "Login",
                                          onPressed: _onSubmit,
                                          state: buttonStateMap[
                                              state.authStatus]!),
                                    ],
                                  ),
                                ),
                              )),
                        ))
                  ],
                )));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocus.removeListener(_onPasswordFocusChange);
    passwordFocus.dispose();
    usernameFocus.removeListener(_onNameFocusChange);
    usernameFocus.dispose();
  }

  @override
  void initState() {
    usernameFocus.addListener(_onNameFocusChange);
    passwordFocus.addListener(_onPasswordFocusChange);
    super.initState();
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

  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<AuthBloc>().add(LoginEvent(
          username: usernameController.text,
          password: passwordController.text));
    } else {
      context
          .read<AuthBloc>()
          .add(const ChangeAuthStatusEvent(authStatus: AuthStatus.failure));
      Future.delayed(const Duration(seconds: 1), () {
        context
            .read<AuthBloc>()
            .add(const ChangeAuthStatusEvent(authStatus: AuthStatus.initial));
      });
    }
  }
}
