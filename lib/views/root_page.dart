import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_shortener_flutter/blocs/auth/auth_bloc.dart';

import '../common/enums.dart';
import '../routes/route_name.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AppStartedEvent());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      debugPrint(
          'AuthStatus: ${state.authStatus} ProcessStatus: ${state.processStatus} Error: ${state.errorMessage}');
      if (state.processStatus == ProcessStatus.failure) {
        debugPrint(
            'Navigate to error page with message: ${state.errorMessage}');
        Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.errorPage,
            arguments: state.errorMessage,
            (route) => false);
      }
      if (state.authStatus == AuthStatus.authenticated) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.homePage, (route) => false);
      } else if (state.authStatus == AuthStatus.unauthenticated) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.loginPage, (route) => false);
      }
    }, builder: (context, state) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
