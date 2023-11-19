import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

Widget submitButton({
  required String text,
  required Function onPressed,
  required ButtonState state,
}) {
  return ProgressButton.icon(
    iconedButtons: {
      ButtonState.idle: IconedButton(
        text: text,
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
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
    onPressed: onPressed,
    state: state,
  );
}
