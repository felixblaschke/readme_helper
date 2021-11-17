import 'dart:io';

import 'package:readme_helper/code_utils.dart';

import 'lines.dart';

String applyCodeMacro(File file, String content) {
  var lines = content.split('\n');

  lines = removeGeneratedBlocks(lines, 'code');
  lines = _generateCodeBlocks(file, lines);

  return lines.join('\n');
}

List<String> _generateCodeBlocks(File file, List<String> lines) {
  var result = Lines();

  lines.read((line, skip) {
    result.add(line);

    if (!skip && line.isMacro('code')) {
      var path = line.macroContent.split(' ')[1];
      var codeFile = File('${file.parent.path}/$path');
      if (codeFile.existsSync()) {
        result.add('```${codeFile.extension}');
        result.addAll(_readCodeFile(codeFile));
        result.add('```');
        result.add(_endComment);
      } else {
        throw 'Error in ${file.path}: Code reference ${codeFile.path} not found';
      }
    }
  });
  return result.data();
}

List<String> _readCodeFile(File file) {
  var lines = file.readAsStringSync().split('\n');
  var result = Lines();

  var indent = 0;
  var skip = false;

  for (var line in lines) {
    if (line.isBegin) {
      indent = line.length - line.trimLeft().length;
      result.discard();
    } else if (line.isSkip) {
      var lineIndent = line.length - line.trimLeft().length;
      var whitespace = '';
      for (var i = 0; i < lineIndent; i++) {
        whitespace += ' ';
      }
      result.add('$whitespace...');
      skip = true;
    } else if (line.isResume) {
      skip = false;
    } else if (line.isEnd) {
      break;
    } else if (!skip) {
      if (line.startsWith('/// ')) {
        line = line.substring(4, line.length);
        if (line.startsWith('{@')) continue;
      }
      result.add(line);
    }
  }

  result.removeIndention(indent);
  var resultLines = result.data();

  if (resultLines.last.trim() == "") {
    resultLines.removeLast();
  }

  return resultLines;
}

extension CodeInstructionsExtensions on String {
  bool get isBegin => trim() == '// #begin';
  bool get isEnd => trim() == '// #end';
  bool get isSkip => trim() == '// #skip';
  bool get isResume => trim() == '// #resume';
}

extension on File {
  String get extension => path.split('.').last;
}

const _endComment = '<!-- // end of #code -->';
