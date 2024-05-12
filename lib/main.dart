import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/home/home_cubit.dart';
import 'routes/route_name.dart';
import 'routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            userRepository: context.read<AuthBloc>().userRepository,
            urlRepository: context.read<AuthBloc>().urlRepository,
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StormX Link',
        theme:
            ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Circular'),
        initialRoute: RouteName.rootPage,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
