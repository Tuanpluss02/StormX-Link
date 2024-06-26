import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:link/views/components/show_confirm_dialog.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/home/home_cubit.dart';
import '../../../common/constant.dart';
import '../../common/enums.dart';
import '../../routes/route_name.dart';

logoutButton(BuildContext context, ScreenType screenType) {
  return Container(
    margin: const EdgeInsets.only(right: 20),
    child: IconButton(
        iconSize: 40,
        onPressed: (() => showConfirmDialog(
            title: "Are you sure you want to logout?",
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.loginPage, (route) => false);
            },
            context: context,
            size: MediaQuery.of(context).size,
            screenType: screenType)),
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
        )),
  );
}

appBar(
    Size size, HomeState state, BuildContext context, ScreenType screenType) {
  return Container(
    margin: const EdgeInsets.all(15),
    width: size.width,
    height: size.height * 0.1,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: Colors.white.withOpacity(0.5),
        width: 2,
      ),
    ),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                logoWiget(),
                screenType == ScreenType.web
                    ? greetingWidget(state)
                    : const SizedBox(),
                logoutButton(context, screenType)
              ],
            ))),
  );
}

logoWiget() {
  return Container(
    margin: const EdgeInsets.only(left: 20),
    child: SvgPicture.asset(
      logoImage,
      height: 50,
      width: 50,
    ),
  );
}

greetingWidget(HomeState state) {
  final currentTime = DateTime.now();
  final currentHour = currentTime.hour;
  String greeting;

  if (currentHour < 12) {
    greeting = 'Good morning';
  } else if (currentHour < 18) {
    greeting = 'Good afternoon';
  } else {
    greeting = 'Good evening';
  }
  return Text(
    "$greeting, ${state.user?.getUsername ?? ''}",
    style: const TextStyle(
        fontSize: 30,
        color: Colors.black,
        // fontFamily: 'RobotReavers',
        fontFamily: 'Circular'),
  );
}
