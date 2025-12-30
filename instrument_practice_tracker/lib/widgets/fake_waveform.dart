import 'package:flutter/material.dart';

class FakeWaveform extends StatefulWidget {
  final bool isRecording;
  const FakeWaveform({super.key, required this.isRecording});

  @override
  State<FakeWaveform> createState() => _FakeWaveformState();
}

class _FakeWaveformState extends State<FakeWaveform>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRecording) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(15, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final multiplier =
                (i % 3 == 0) ? 1.0 : (i % 3 == 1 ? 0.6 : 0.35);

            final height = (20 + (30 * _controller.value)) * multiplier;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                width: 5,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
