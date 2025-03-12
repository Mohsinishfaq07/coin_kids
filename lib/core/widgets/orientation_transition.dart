import 'package:flutter/material.dart';

import 'rotation_instruction.dart';

class OrientationTransition extends StatefulWidget {
  final Widget child;
  final bool toPortrait;
  final Duration instructionDuration;
  final bool showInstruction;

  const OrientationTransition({
    Key? key,
    required this.child,
    required this.toPortrait,
    this.instructionDuration = const Duration(seconds: 3),
    this.showInstruction = false,
  }) : super(key: key);

  @override
  State<OrientationTransition> createState() => _OrientationTransitionState();
}

class _OrientationTransitionState extends State<OrientationTransition> {
  late bool _showInstruction;

  @override
  void initState() {
    super.initState();
    _showInstruction = widget.showInstruction;
    if (_showInstruction) {
      _startInstructionTimer();
    }
  }

  @override
  void didUpdateWidget(OrientationTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showInstruction != oldWidget.showInstruction) {
      setState(() {
        _showInstruction = widget.showInstruction;
      });
      if (_showInstruction) {
        _startInstructionTimer();
      }
    }
  }

  void _startInstructionTimer() {
    Future.delayed(widget.instructionDuration, () {
      if (mounted) {
        setState(() {
          _showInstruction = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _showInstruction
          ? RotationInstruction(toPortrait: widget.toPortrait)
          : widget.child,
    );
  }
}
