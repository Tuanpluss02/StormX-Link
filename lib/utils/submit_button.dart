import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';

class SubmitButton extends StatefulWidget {
  final Function? onPressed;
  final BoolVar isSuccess;
  final BoolVar isSubmitting;
  const SubmitButton(
      {super.key,
      required this.onPressed,
      required this.isSubmitting,
      required this.isSuccess});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: ProgressButton.icon(iconedButtons: {
          ButtonState.idle: IconedButton(
              text: 'Send',
              icon: const Icon(Icons.send, color: Colors.white),
              color: Colors.deepPurple.shade500),
          ButtonState.loading:
              IconedButton(text: 'Loading', color: Colors.deepPurple.shade700),
          ButtonState.fail: IconedButton(
              text: 'Failed',
              icon: const Icon(Icons.cancel, color: Colors.white),
              color: Colors.red.shade300),
          ButtonState.success: IconedButton(
              text: 'Success',
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        }, onPressed: onPressedIconWithText, state: stateTextWithIcon),
      ),
    );
  }

  void onPressedIconWithText() {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        widget.onPressed!();
        // while (widget.isSubmitting.val) {
        //   Future.delayed(const Duration(seconds: 1));
        // }
        Future.delayed(
          Duration(seconds: widget.isSubmitting.val ? 2 : 0),
          () {
            setState(
              () {
                stateTextWithIcon = widget.isSuccess.val
                    ? ButtonState.success
                    : ButtonState.fail;
              },
            );
          },
        );
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(
      () {
        stateTextWithIcon = stateTextWithIcon;
      },
    );
  }
}
