import 'dart:io';

import 'package:readme_helper/process_file.dart';
import 'package:test/test.dart';

void main() {
  test('can handle example files', () {
    var content =
        File('${Directory.current.path}/test/data/test1_input_markdown')
            .readAsStringSync();

    // only used as relative import path for code
    var contentFile = File('${Directory.current.path}/test/data/markdown.md');

    var expectedOutput =
        File('${Directory.current.path}/test/data/test1_expected_output')
            .readAsStringSync();

    expect(processContent(contentFile, content), expectedOutput);
  });
}
