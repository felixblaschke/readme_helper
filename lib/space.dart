import 'dart:io';

import 'package:readme_helper/macros.dart';

import 'lines.dart';

String applySpaceMacro(File file, String content) {
  var lines = content.split('\n');

  lines = removeGeneratedBlocks(lines, 'space');
  lines = _generateCodeBlocks(file, lines);

  return lines.join('\n');
}

List<String> _generateCodeBlocks(File file, List<String> lines) {
  var result = Lines();

  for (var line in lines) {
    result.add(line);

    if (line.isMacro('space')) {
      var space = int.tryParse(line.macroContent.split(' ')[1]) ?? 1;
      for (var i = 0; i < space; i++) {
        result.add('');
        result.add('&nbsp;');
      }
      result.add(_endComment);
    }
  }
  return result.data();
}

const _endComment = '<!-- // end of #space -->';
