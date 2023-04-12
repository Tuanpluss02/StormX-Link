import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';

class SubmitButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function? onPressed;
  final BoolVar isSuccess;
  final String textSuccess;
  final String textFail;

  SubmitButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.isSuccess,
    required this.textSuccess,
    required this.textFail,
  });

  final Rx<ButtonState> stateOnlyText = ButtonState.idle.obs;
  final Rx<ButtonState> stateTextWithIcon = ButtonState.idle.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: Obx(
          () => ProgressButton.icon(
            iconedButtons: {
              ButtonState.idle: IconedButton(
                text: text,
                icon: icon,
                color: Colors.black54,
              ),
              ButtonState.loading: const IconedButton(
                text: 'Loading',
                color: Color.fromARGB(255, 85, 85, 85),
              ),
              ButtonState.fail: IconedButton(
                text: 'Failed',
                icon: const Icon(Icons.cancel, color: Colors.white),
                color: Colors.red.shade300,
              ),
              ButtonState.success: IconedButton(
                text: 'Success',
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                color: Colors.green.shade400,
              ),
            },
            onPressed: onPressedIconWithText,
            state: stateTextWithIcon.value,
          ),
        ),
      ),
    );
  }

  void onPressedIconWithText() {
    switch (stateTextWithIcon.value) {
      case ButtonState.idle:
        stateTextWithIcon.value = ButtonState.loading;
        onPressed!();
        Future.delayed(
          const Duration(seconds: 1),
          () {
            stateTextWithIcon.value =
                isSuccess.val ? ButtonState.success : ButtonState.fail;
          },
        );
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon.value = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon.value = ButtonState.idle;
        break;
    }
  }
}
