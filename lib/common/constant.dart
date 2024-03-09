import 'package:progress_state_button/progress_button.dart';

import 'enums.dart';

const String apiDomain = "https://url.stormx.space/";
const String baseApiUrl = "https://url.stormx.space/api/v1/";
const String apiAuthUrl = "${baseApiUrl}auth";
const String apiUserUrl = "${baseApiUrl}user";
const String apiUrl = "${baseApiUrl}url";

const String bgImage = "assets/images/background.jpg";
const String logoImage = "assets/images/logo.svg";
const String riveLoginAnimation =
    'https://public.rive.app/community/runtime-files/3645-7621-remix-of-login-machine.riv';

const String riveSignupAnimation =
    'https://public.rive.app/community/runtime-files/6608-12793-hero.riv';

const Map<AuthStatus, ButtonState> buttonStateMap = {
  AuthStatus.loading: ButtonState.loading,
  AuthStatus.success: ButtonState.success,
  AuthStatus.initial: ButtonState.idle,
  AuthStatus.failure: ButtonState.fail,
};

const Map<UrlActionState, ButtonState> urlButtonStateMap = {
  UrlActionState.loading: ButtonState.loading,
  UrlActionState.success: ButtonState.success,
  UrlActionState.initial: ButtonState.idle,
  UrlActionState.failure: ButtonState.fail,
};
