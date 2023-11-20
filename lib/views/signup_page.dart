import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:url_shortener_flutter/components/blur_container.dart';
import 'package:url_shortener_flutter/components/rive_animation.dart';

import '../blocs/auth/auth_bloc.dart';
import '../common/constant.dart';
import '../common/enums.dart';
import '../components/custom_snackbar.dart';
import '../routes/route_name.dart';

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
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  Artboard? bearArtboard;
  SMIBool? isChecking, isHandsUp;
  SMITrigger? trigSuccess, numLook, trigFail;
  StateMachineController? stateMachineController;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint("state: ${state.authStatus}");
        if (state.authStatus == AuthStatus.success) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.homePage, (route) => false);
          });
          context.read<AuthBloc>().add(
              const ChangeAppStatusEvent(appStatus: AppStatus.authenticated));
        } else {
          showSnackBar(
              context: context,
              title: 'Login Failed',
              message: 'Username or Password is invalid',
              contentType: ContentType.failure);
        }
        Future.delayed(const Duration(seconds: 1), () {
          context
              .read<AuthBloc>()
              .add(const ChangeAuthStatusEvent(authStatus: AuthStatus.initial));
        });
      },
      builder: (context, state) {
        return Scaffold(
            body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(bgImage), fit: BoxFit.cover)),
                child: blurContainer(
                    child: const Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 300,
                            width: 450,
                            child: RiveAnimation.network(
                              riveSignupAnimation,
                              // artboard: "404",
                              // stateMachines: ["State Machine 1"],
                              fit: BoxFit.contain,
                            )))
                  ],
                ))));
      },
    );
  }
}
