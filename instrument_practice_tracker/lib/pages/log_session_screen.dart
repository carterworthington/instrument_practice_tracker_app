import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';
import 'package:instrument_practice_tracker/providers/session_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:instrument_practice_tracker/widgets/fake_waveform.dart';
import 'dart:async';
import 'package:instrument_practice_tracker/widgets/audio_playing_indicator.dart';

class LogPage extends ConsumerStatefulWidget {
  const LogPage({super.key});

  @override
  ConsumerState<LogPage> createState() => _LogPageState();
}

class _LogPageState extends ConsumerState<LogPage> {
  final instrumentController = TextEditingController();
  final notesController = TextEditingController();

  final recorder = AudioRecorder();
  final player = AudioPlayer();
  bool isPlaying = false;

  String? audioPath;
  bool isRecording = false;

  int secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Sync UI with true audio state
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
    instrumentController.dispose();
    notesController.dispose();
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  // ----------------------------------------------------
  // START RECORDING
  // ----------------------------------------------------
  Future<void> _startRecording() async {
    final hasPermission = await recorder.hasPermission();
    if (!hasPermission) {
      print("No mic permission");
      return;
    }

    // reset timer
    secondsElapsed = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => secondsElapsed++);
    });

    // app document directory
    final dir = await getApplicationDocumentsDirectory();

    // unique file name
    final filePath = p.join(
      dir.path,
      'session_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    // start recording
    await recorder.start(const RecordConfig(), path: filePath);

    setState(() => isRecording = true);
  }

  // ----------------------------------------------------
  // STOP RECORDING
  // ----------------------------------------------------
  Future<void> _stopRecording() async {
    final path = await recorder.stop();

    _timer?.cancel(); // stop the timer
    setState(() {
      isRecording = false;
      audioPath = path;
    });
  }

  // ----------------------------------------------------
  // PLAY AUDIO
  // ----------------------------------------------------
  Future<void> _playAudio() async {
    if (audioPath != null) {
      await player.setFilePath(audioPath!);
      await player.play();
    }
  }


  // ----------------------------------------------------
  // STOP AUDIO
  // ----------------------------------------------------

  Future<void> _stopAudio() async {
    await player.stop();
  }

  // ----------------------------------------------------
  // SAVE SESSION TO DB
  // ----------------------------------------------------
  Future<void> _saveSession() async {
    final session = LogSession(
      instrument: instrumentController.text.trim(),
      notes: notesController.text.trim(),
      audioPath: audioPath,
      durationSeconds: secondsElapsed,
      createdAt: DateTime.now().toIso8601String(),
    );

    final db = ref.read(dbProvider);
    await db.insertSession(session);
    ref.invalidate(loadSessionsProvider);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Session")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: instrumentController,
              decoration: const InputDecoration(labelText: "Instrument"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notes"),
              maxLines: 2,
            ),

            const SizedBox(height: 32),

            // Waveform
            SizedBox(
              height: 60, // keeps layout still
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: isRecording ? 1 : 0,
                child: FakeWaveform(isRecording: isRecording),
              ),
            ),
            const SizedBox(height: 20),

            if (isRecording)
              Text(
                "${(secondsElapsed ~/ 60).toString().padLeft(2, '0')}:${(secondsElapsed % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),

            if (!isRecording)
              ElevatedButton(
                onPressed: _startRecording,
                child: const Text("Start Recording"),
              )
            else
              ElevatedButton(
                onPressed: _stopRecording,
                child: const Text("Stop Recording"),
              ),

            const SizedBox(height: 16),
            if (audioPath != null)
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
                    // Play button (only when not playing)
                    if (!isPlaying)
                      ElevatedButton(
                        onPressed: _playAudio,
                        child: const Text("Play"),
                      ),

                    // Stop playback button (only when playing)
                    if (isPlaying)
                      ElevatedButton(
                        onPressed: _stopAudio,
                        child: const Text("Stop"),
                      ),

                    // Pulsing indicator (only when playing)
                    if (isPlaying)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: AudioPlayingIndicator(),
                      ),
                  ],
                ),
              ),

            const Spacer(),

            ElevatedButton(
              onPressed: _saveSession,
              child: const Text("Save Session"),
            ),
          ],
        ),
      ),
    );
  }
}
