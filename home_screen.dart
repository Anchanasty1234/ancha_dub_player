import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? videoPath;
  String? audioPath;

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        videoPath = result.files.single.path;
      });
    }
  }

  Future<void> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        audioPath = result.files.single.path;
      });
    }
  }

  void goToPreview() {
    if (videoPath != null && audioPath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            videoPath: videoPath!,
            audioPath: audioPath!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ancha Dub Player')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickVideo,
              child: const Text('Pilih Video'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickAudio,
              child: const Text('Pilih Lagu'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: (videoPath != null && audioPath != null) ? goToPreview : null,
              child: const Text('Lanjut ke Preview'),
            ),
          ],
        ),
      ),
    );
  }
}
