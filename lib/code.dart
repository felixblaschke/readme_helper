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
      var args = line.macroContent.split(' ')..removeRange(0, 2);

      var codeFile = File('${file.parent.path}/$path');
      if (codeFile.existsSync()) {
        result.addAll(_readCodeFile(codeFile, args));
        result.add(_endComment);
      } else {
        throw 'Error in ${file.path}: Code reference ${codeFile.path} not found';
      }
    }
  });
  return result.data();
}

List<String> _readCodeFile(File file, List<String> args) {
  var lines = file.readAsStringSync().split('\n');
  var result = Lines();

  var indent = 0;
  var skip = false;
  bool isSource = false;
  List<String> sourceList = [];
  bool isIgnoreDoc = args.contains('ignoreDoc');
  bool isIgnoreSourceDoc = args.contains('ignoreSourceDoc');

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
      if (isIgnore(line, args)) continue;
      if (isIgnoreDoc && line.isDocument) continue;
      if (isIgnoreSourceDoc &&
          (line.startsWith(' ') && line.trimLeft().isDocument)) continue;
      if (!line.isDocument) {
        if (isSource == false) {
          isSource = true;
          // sourceList.add('```${file.extension}');
          sourceList = [];
        }
        sourceList.add(line);
      }

      if (line.isDocument) {
        if (isSource) {
          isSource = false;
          if (isNotEmptySource(sourceList)) {
            result.add('```${file.extension}');
            result.addAll(sourceList);
            result.add('```');
          }
        }
        line = line.trimLeft();
        line = line.substring(3, line.length);
        if (line.trimLeft().startsWith('{@')) continue;
        result.add(line);
      }
    }
  }

  if (sourceList.isNotEmpty) {
    if (isNotEmptySource(sourceList)) {
      result.add('```${file.extension}');
      result.addAll(sourceList);
      result.add('```');
    }
  }

  result.removeIndention(indent);
  var resultLines = result.data();

  if (resultLines.last.trim() == "") {
    resultLines.removeLast();
  }

  return resultLines;
}

bool isNotEmptySource(List<String> sourceList) =>
    !sourceList.every((element) => element.trim() == '');

bool isIgnore(String line, List<String> args) {
  bool isContinue = false;
  for (var arg in args) {
    if (arg.startsWith('ignore:')) {
      var key = arg.substring(7, arg.length);
      if (line.contains(key)) {
        isContinue = true;
        break;
      }
    }
  }
  return isContinue;
}

bool ignoreDoc(String line) {
  return line.isDocument;
}

extension CodeInstructionsExtensions on String {
  bool get isBegin => trim() == '// #begin';
  bool get isEnd => trim() == '// #end';
  bool get isSkip => trim() == '// #skip';
  bool get isResume => trim() == '// #resume';
}

extension SourceContendExtensions on String {
  bool get isDocument => startsWith('///');
}

extension on File {
  String get extension => path.split('.').last;
}

const _endComment = '<!-- // end of #code -->';
