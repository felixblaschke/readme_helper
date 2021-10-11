import 'dart:io';

import 'package:readme_helper/include.dart';
import 'package:readme_helper/code_utils.dart';
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
  content = applyUsageHint(content);

  return content;
}

String applyUsageHint(String content) {
  var lines = content.split('\n');

  var contentUsesMacros = lines.any((line) => line.isAnyMacro());
  if (contentUsesMacros && lines.first != usageHint) {
    return [usageHint, ...lines].join('\n');
  }

  return content;
}

const usageHint =
    '<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->';
