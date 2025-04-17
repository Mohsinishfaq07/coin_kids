import 'package:flutter/material.dart';

import 'rotation_instruction.dart';

class OrientationTransition extends StatefulWidget {
  final Widget child;
  final bool toPortrait;
  final Duration instructionDuration;
  final bool showInstruction;

  const OrientationTransition({
    super.key,
    required this.child,
    required this.toPortrait,
    this.instructionDuration = const Duration(seconds: 3),
    this.showInstruction = false,
  });

  @override
  State<OrientationTransition> createState() => _OrientationTransitionState();
}

class _OrientationTransitionState extends State<OrientationTransition> with SingleTickerProviderStateMixin {
  late bool _showInstruction;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _showInstruction = widget.showInstruction;
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (_showInstruction) {
      _startInstructionTimer();
      _animationController.forward();
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
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _startInstructionTimer() {
    Future.delayed(widget.instructionDuration, () {
      if (mounted) {
        setState(() {
          _showInstruction = false;
        });
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showInstruction)
          FadeTransition(
            opacity: _fadeAnimation,
            child: RotationInstruction(toPortrait: widget.toPortrait),
          ),
      ],
    );
  }
}
