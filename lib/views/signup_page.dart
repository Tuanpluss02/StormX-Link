import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_shortener_flutter/views/components/blur_container.dart';

import '../blocs/auth/auth_bloc.dart';
import '../common/constant.dart';
import '../common/enums.dart';
import '../routes/route_name.dart';
import '../utils/screen_info.dart';
import '../utils/validate_extension.dart';
import 'components/custom_snackbar.dart';
import 'components/custom_text_field.dart';
import 'components/submit_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenType = ScreenInfo().getScreenType(context);
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
              width: screenType == ScreenType.web
                  ? size.width * 0.4
                  : size.width * 0.9,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text('Sign Up',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontFamily: 'RobotReavers',
                          )),
                      const SizedBox(height: 30),
                      customTextFormField(
                          controller: usernameController,
                          labelText: 'Username',
                          validator: usernameValidator),
                      const SizedBox(height: 20),
                      customTextFormField(
                          obscureText: true,
                          controller: passwordController,
                          labelText: 'Password',
                          validator: passwordValidator),
                      const SizedBox(height: 20),
                      customTextFormField(
                          obscureText: true,
                          controller: confirmPasswordController,
                          labelText: 'Confirm Password',
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Confirm Password is required';
                            } else if (val != passwordController.text.trim()) {
                              return 'Confirm Password must match Password';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      submitButton(
                          text: "Sign Up",
                          onPressed: _onSubmit,
                          state: buttonStateMap[state.authStatus]!),
                      const SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, RouteName.loginPage, (route) => false);
                          },
                          child: const Text.rich(
                            TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                children: [
                                  TextSpan(
                                      text: 'Sign In',
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
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.homePage, (route) => false);
      });
      context
          .read<AuthBloc>()
          .add(const ChangeAppStatusEvent(appStatus: AppStatus.authenticated));
    } else if (state.authStatus == AuthStatus.failure) {
      showSnackBar(
          context: context,
          title: 'Sign Up Failed',
          message: 'Please try again later',
          contentType: ContentType.failure);
      Future.delayed(const Duration(seconds: 1), () {
        context
            .read<AuthBloc>()
            .add(const ChangeAuthStatusEvent(authStatus: AuthStatus.initial));
      });
    }
  }

  _onSubmit() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(CreateAccountEvent(
            username: usernameController.text.trim(),
            password: passwordController.text.trim(),
          ));
    }
  }
}
