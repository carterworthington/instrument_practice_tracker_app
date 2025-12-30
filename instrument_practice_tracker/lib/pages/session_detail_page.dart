import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';
import 'package:instrument_practice_tracker/widgets/audio_playing_indicator.dart';

class SessionDetailPage extends StatefulWidget {
  final LogSession session;

  const SessionDetailPage({super.key, required this.session});

  @override
  State<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  final player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    
    player.playerStateStream.listen((state) {
      final playing = state.playing;
      final finished = state.processingState == ProcessingState.completed;

      setState(() {
        if (finished) {
          isPlaying = false;
        } else {
          isPlaying = playing;
        }
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    final path = widget.session.audioPath;
    if (path != null) {
      await player.setFilePath(path);
      await player.play();
    }
  }

  Future<void> _stop() async {
    await player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;

    return Scaffold(
      appBar: AppBar(title: Text(s.instrument)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${s.createdAt}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            const Text(
              "Notes:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(s.notes, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 40),

            if (s.audioPath != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: isPlaying
                      ? Colors.blueAccent.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPlaying ? Colors.blueAccent : Colors.grey.shade400,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    if (!isPlaying)
                      ElevatedButton(
                        onPressed: _play,
                        child: const Text("Play Recording"),
                      ),

                    if (isPlaying)
                      ElevatedButton(
                        onPressed: _stop,
                        child: const Text("Stop"),
                      ),

                    if (isPlaying)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: AudioPlayingIndicator(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
