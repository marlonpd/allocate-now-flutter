import 'dart:async';
import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  String appFoldername = 'back';

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/counter.txt');
  // }

  Future<File> writeBackUp(String content) async {
    final file = await _generateFilename;

    // Write the file
    return file.writeAsString('$content');
  }

  Future<File> get _generateFilename async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    int filename = DateTime.now().millisecondsSinceEpoch;
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$appFoldername/$filename.dat'; // 3

    return File(filePath);
  }

  // Future<List<String>> get getListOfLocalFile async {
  //   file = io.Directory("$directory/resume/").listSync();
  // }
}
