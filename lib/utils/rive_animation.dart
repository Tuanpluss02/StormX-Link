import 'package:rive/rive.dart';

/// It's a utility class that creates a StateMachineController from an Artboard and adds it to the
/// Artboard
mixin RivetUtils {
  static StateMachineController getRiveController(Artboard artboard,
      {stateMachine = "State Machine 1"}) {
    StateMachineController controller =
        StateMachineController.fromArtboard(artboard, stateMachine)!;
    artboard.addController(controller);
    return controller;
  }
}
