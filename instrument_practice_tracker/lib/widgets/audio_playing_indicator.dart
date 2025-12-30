import 'package:flutter/material.dart';

class AudioPlayingIndicator extends StatefulWidget {
  const AudioPlayingIndicator({super.key});

  @override
  State<AudioPlayingIndicator> createState() => _AudioPlayingIndicatorState();
}

class _AudioPlayingIndicatorState extends State<AudioPlayingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: const Icon(
        Icons.equalizer,
        size: 32,
        color: Colors.blueAccent,
      ),
    );
  }
}
