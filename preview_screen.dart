import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import '../services/export_service.dart';

class PreviewScreen extends StatefulWidget {
  final String videoPath;
  final String audioPath;

  const PreviewScreen({super.key, required this.videoPath, required this.audioPath});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  double _audioOffset = 0.0;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(Uri.parse(widget.videoPath))
      ..initialize().then((_) => setState(() {}));
    _audioPlayer = AudioPlayer();
    _audioPlayer.setFilePath(widget.audioPath);
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void playBoth() async {
    await _videoController.seekTo(Duration.zero);
    await _audioPlayer.seek(Duration(milliseconds: (_audioOffset * 1000).round()));
    _videoController.play();
    _audioPlayer.play();
  }

  void stopBoth() {
    _videoController.pause();
    _audioPlayer.pause();
  }

  Future<void> exportVideo() async {
    setState(() => _isExporting = true);
    final outputPath = await ExportService.combineVideoAndAudio(
      videoPath: widget.videoPath,
      audioPath: widget.audioPath,
      audioOffset: _audioOffset,
    );
    setState(() => _isExporting = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Video disimpan: $outputPath')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Sinkronisasi')),
      body: Column(
        children: [
          if (_videoController.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),
          const SizedBox(height: 16),
          Text('Offset Audio: ${_audioOffset.toStringAsFixed(2)} detik'),
          Slider(
            min: -2.0,
            max: 2.0,
            divisions: 80,
            value: _audioOffset,
            onChanged: (value) => setState(() => _audioOffset = value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: playBoth,
                child: const Text('Play'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: stopBoth,
                child: const Text('Stop'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isExporting
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                  onPressed: exportVideo,
                  icon: const Icon(Icons.download),
                  label: const Text('Ekspor ke MP4'),
                ),
        ],
      ),
    );
  }
}
