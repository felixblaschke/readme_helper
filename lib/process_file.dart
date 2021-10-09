import 'dart:io';

import 'package:readme_helper/include.dart';
import 'package:readme_helper/toc.dart';

import 'code.dart';
import 'space.dart';

void processFile(File file) {
  print('Processing ${file.path}...');
  var content = file.readAsStringSync();
  var result = processContent(file, content);

  file.writeAsStringSync(result);
}

String processContent(File file, String content) {
  content = applyIncludeMacro(file, content);
  content = applyCodeMacro(file, content);
  content = applyTocMacro(file, content);
  content = applySpaceMacro(file, content);

  return content;
}
