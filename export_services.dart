import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ExportService {
  static Future<String> combineVideoAndAudio({
    required String videoPath,
    required String audioPath,
    required double audioOffset,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final outputPath = '${dir.path}/ancha_dub_$timestamp.mp4';

    final offsetArg = audioOffset >= 0
        ? '-itsoffset $audioOffset -i "$audioPath"'
        : '-i "$audioPath"';
    final delayFilter = audioOffset < 0
        ? '-af "adelay=${(-audioOffset * 1000).round()}|${(-audioOffset * 1000).round()}"'
        : '';

    final cmd =
        '-i "$videoPath" $offsetArg -map 0:v:0 -map 1:a:0 $delayFilter -c:v copy -shortest "$outputPath"';

    await FFmpegKit.execute(cmd);
    return outputPath;
  }
}
