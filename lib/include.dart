import 'dart:io';

import 'package:readme_helper/code_utils.dart';
import 'package:readme_helper/process_file.dart';

import 'lines.dart';

String applyIncludeMacro(File file, String content) {
  var lines = content.split('\n');
  var result = Lines();

  lines = removeGeneratedBlocks(lines, 'include');

  lines.read((line, skip) {
    result.add(line);

    if (!skip && line.isMacro("include")) {
      var path = line.macroContent.split(' ')[1];
      var includeFile = File('${file.parent.path}/$path');
      if (includeFile.existsSync()) {
        result.addAll(_readIncludeFile(includeFile));
        result.add(_endComment);
      } else {
        throw 'Error in ${file.path}: File to include ${includeFile.path} not found';
      }
    }
  });
  return result.data().join('\n');
}

List<String> _readIncludeFile(File includeFile) {
  var lines = includeFile.readAsStringSync().split('\n');

  // Process included file
  lines = processContent(includeFile, lines.join('\n')).split('\n');

  // Remove any macros
  lines = lines
      .where((line) =>
          !line.isAnyMacro() && !line.isAnyMacroEnd() && line != usageHint)
      .toList();

  return lines;
}

const _endComment = '<!-- // end of #include -->';
