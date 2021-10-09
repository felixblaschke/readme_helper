import 'dart:io';

import 'package:readme_helper/process_file.dart';

void main(List<String> args) {
  print('Hello, this is Readme Helper!');

  if (args.isEmpty) {
    print(' I will scan your current directory for markdown files...');
    scanDirectory(Directory.current);
  }

  if (args.length == 1) {
    var file = File(args[0]);
    print(' I will process only $file...');
    processFile(file);
  }
}

void scanDirectory(Directory directory) {
  for (FileSystemEntity entity in directory.listSync()) {
    if (entity.isMarkdownFile) {
      processFile(entity as File);
    } else if (entity is Directory) {
      scanDirectory(entity);
    }
  }
}

extension on FileSystemEntity {
  bool get isMarkdownFile => this is File && path.toLowerCase().endsWith('.md');
}
