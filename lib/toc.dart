import 'dart:convert';
import 'dart:io';

import 'package:readme_helper/code_utils.dart';

import 'lines.dart';

String applyTocMacro(File file, String content) {
  var lines = LineSplitter.split(content).toList();
  var result = Lines();

  lines = removeGeneratedBlocks(lines, 'toc');

  var toc = _extractTableOfContents(lines);

  lines.read((line, skip) {
    result.add(line);

    if (!skip && line.isMacro("toc")) {
      result.add('## Table of Contents');
      for (var toplevel in toc.subsections) {
        result.add('');
        result.add('[**${toplevel.title}**](${toplevel.link})');
        for (var sublevel in toplevel.subsections) {
          result.add('  - [${sublevel.title}](${sublevel.link})');
        }
      }
      result.add(_endComment);
    }
  });
  return result.data().join('\n');
}

Section _extractTableOfContents(List<String> lines) {
  var toc = Section('toc', '');

  lines.read((line, skip) {
    if (!skip && line.trim().startsWith('#')) {
      var depth = line.indexOf(' ');
      var title = line.substring(depth + 1);
      var link = '#' + title.toLowerCase().replaceAll(' ', '-');

      if (depth == 2) {
        toc.add(Section(title, link));
      } else if (depth == 3) {
        toc.last.add(Section(title, link));
      }
    }
  });

  return toc;
}

const _endComment = '<!-- // end of #toc -->';

class Section {
  String title = '';
  String link = '';
  List<Section> subsections = [];

  Section(this.title, this.link);

  void add(Section section) => subsections.add(section);
  Section get last => subsections.last;
}
