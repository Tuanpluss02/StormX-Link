import 'package:flutter/material.dart';
import 'package:url_shortener_flutter/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_shortener_flutter/views/login_page.dart';

import '../common/enums.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.authStatus == AuthStatus.authenticated) {
          return Container();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
