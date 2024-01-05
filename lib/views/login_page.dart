import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:url_shortener_flutter/common/constant.dart';
import 'package:url_shortener_flutter/common/enums.dart';
import 'package:url_shortener_flutter/components/blur_container.dart';
import 'package:url_shortener_flutter/components/submit_button.dart';
import 'package:url_shortener_flutter/utils/validate_extension.dart';

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
  SMIBool? isChecking, isHandsUp;
  SMITrigger? trigSuccess, trigFail;
  StateMachineController? stateMachineController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) => _listener(state, context),
      builder: (context, state) {
        return Scaffold(
            body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(bgImage), fit: BoxFit.cover)),
          child: blurContainer(
              width: size.width * 0.4,
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
                      riveAnimation(
                          onInit: (artboard) {
                            stateMachineController =
                                StateMachineController.fromArtboard(
                                    artboard, "Login Machine");
                            if (stateMachineController != null) {
                              artboard.addController(stateMachineController!);
                              var inputListener =
                                  stateMachineController!.inputs as List;
                              isChecking = inputListener.first as SMIBool;
                              isHandsUp = inputListener[1] as SMIBool;
                              trigSuccess = inputListener[2] as SMITrigger;
                              trigFail = inputListener.last as SMITrigger;
                            }
                          },
                          riveNetworkUrl: riveLoginAnimation),
                      customTextFormField(
                          obscureText: false,
                          focusNode: usernameFocus,
                          controller: usernameController,
                          labelText: 'Username',
                          validator: usernameValidator),
                      const SizedBox(height: 20),
                      customTextFormField(
                          obscureText: true,
                          focusNode: passwordFocus,
                          controller: passwordController,
                          labelText: 'Password',
                          validator: passwordValidator),
                      const SizedBox(height: 20),
                      submitButton(
                          text: "Login",
                          onPressed: _onSubmit,
                          state: buttonStateMap[state.authStatus]!),
                      const SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteName.signupPage);
                          },
                          child: const Text.rich(
                            TextSpan(
                                text: 'Don\'t have an account? ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                children: [
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 243, 89),
                                          fontSize: 16))
                                ]),
                          ))
                    ],
                  ),
                ),
              )),
        ));
      },
    );
  }

  void _listener(AuthState state, BuildContext context) {
    if (state.authStatus == AuthStatus.success) {
      trigSuccess!.fire();
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.homePage, (route) => false);
      });
      context
          .read<AuthBloc>()
          .add(const ChangeAppStatusEvent(appStatus: AppStatus.authenticated));
    } else if (state.authStatus == AuthStatus.failure) {
      trigFail!.fire();
      showSnackBar(
          context: context,
          title: 'Login Failed',
          message: 'Username or Password is invalid',
          contentType: ContentType.failure);
      Future.delayed(const Duration(seconds: 1), () {
        context
            .read<AuthBloc>()
            .add(const ChangeAuthStatusEvent(authStatus: AuthStatus.initial));
      });
    }
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
          username: usernameController.text.trim(),
          password: passwordController.text.trim()));
    } else {
      context
          .read<AuthBloc>()
          .add(const ChangeAuthStatusEvent(authStatus: AuthStatus.failure));
    }
  }
}
