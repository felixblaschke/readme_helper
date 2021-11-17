<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
# readme_helper

Helpful code generator for the README and other markdown files.

## Quickstart

**1.** Install or update **readme_helper**:
```bash
flutter pub global activate readme_helper
# or
readme_helper
```

**2.** Start using these "magical" comment commands:

```md
Insert code example from external file:
<!-- #code path/to/file.dart -->

Create a table of contents based on used headlines:
<!-- #toc -->

This will include another markdown file:
<!-- #include path/to/other_markdown.md -->
```

**3.** Run **readme_helper** for current project:
```bash
flutter pub global run readme_helper
```

<!-- #toc -->
## Table of Contents

[**Quickstart**](#quickstart)

[**Motivation**](#motivation)

[**Usage**](#usage)

[**Commands**](#commands)
  - [Code embedding](#code-embedding)
  - [Table of Contents generation](#table-of-contents-generation)
  - [Include markdown files](#include-markdown-files)
  - [Generate line breaks](#generate-line-breaks)
<!-- // end of #toc -->

## Motivation

A good documentation is the key in connecting package creators and developers.

Embedding **code examples** is essential, but they might deprecate over the time. 
This tool enables you to use external code files, the correctness is ensured by your IDE.

Additional tooling like **markdown inclusion** or **table of contents generation**, will help you save time.

## Usage

The **readme_helper** is a Dart application, that can be installed or updated with:

```bash
flutter pub global activate readme_helper
```

You can run the **readme_helper** with:
```bash
flutter pub global run readme_helper
```

It will take care of all markdown files within the current directory and it's sub-directories. 

Alternately you can process only a single file with:
```bash
flutter pub global run readme_helper path/to/file.md
```


## Commands

You can specify commands by using HTML comments in your markdown files. Each **readme_helper** command starts with a `#`:

```md
<!-- #command argument -->
```

### Code embedding

You can embed external files by defining the relative path to it.

```md
<!-- #code path/to/code.dart -->
```

This will add a code block with the content of that file.

#### Scope comments

You can use comments to control the part of the external file shown.

```dart
import 'dart:math';

// #begin
class MyClass {
  // #skip
  int someMethod() {
    return Random().nextInt(1);
  }
  // #resume

  String interestingMethod() {
    return 'Foo';
  }
}
// #end
```

This will add the following code block:


```dart
class MyClass {
  ...

  String interestingMethod() {
    return 'Foo';
  }
}
```

#### Indentions

By indenting the `// #begin` scope comments, you can hint to remove leading whitespace.

```dart
class AnotherClass {
  // #begin
  int importantMethod() {
    return 42;
  }
  // #end
}
```

This will add the following code block:
```dart
int importantMethod() {
  return 42;
}
```

### Table of Contents generation

The **readme_helper** will scan all markdown headlines (`##` and `###`) and generate a table of contents.

```md
# project_name

<!-- #toc -->

## chapter a
### section 1
### section 2

## chapter b
### section 3
### section 4
```

This will create something like this:

- [**chapter a**](#)
  - [section 1](#)
  - [section 2](#)
- [**chapter b**](#)
  - [section 3](#)
  - [section 4](#)

### Include markdown files

You can include parts from other files into the current markdown file, by using an include:

```md
<!-- #include path/to/part.md -->
```

### Generate line breaks

By default you can't have more then one new line. For esthetics you might want to extend this limit.

```md
<!-- #space 2 -->
```

This will generate line breaks with `&nbsp;` characters.