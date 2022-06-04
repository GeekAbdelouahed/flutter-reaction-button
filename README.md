# Flutter Reaction Button

[![pub package](https://img.shields.io/pub/v/flutter_reaction_button.svg)](https://pub.dartlang.org/packages/flutter_reaction_button)

Flutter button reaction it is fully customizable widget such as Facebook reaction button.

## Preview

<img src="https://github.com/GeekAbdelouahed/flutter-reaction-button/raw/doc/images/Preview.png"/>


## Demo

<video src="https://user-images.githubusercontent.com/22131872/171996907-b769d8d4-b137-460b-808f-71e24a4d03a8.mp4"></video>


## Usage

[Include 'flutter_reaction_button' from Dart Pub.](https://pub.dartlang.org/packages/flutter_reaction_button)

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  flutter_reaction_button: <last-version>
```

Next, import 'flutter_reaction_button.dart' into your dart code.

```dart
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
```

## Parameters
| parameter                  | description                                                                           | default                                                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| OnReactionChanged          | triggered when reaction button value change                                           ||
| reactions                  | reactions appear in reactions box when long pressed on ReactionnButtonToggle or click on ReactionButton ||
| initialReaction            | Default reaction button widget                                                        | first item in reactions list |
| boxPosition                | Vertical position of reactions box relative to the button                             | VerticalPosition.TOP |
| boxHorizontalPosition      | Horizontal position of reactions box relative to the button                           | HorizontalPosition.START |
| boxOffset                  | Offset to reposition the box from the computed place                                  | Offset.zero |
| boxColor                   | Reactions box color                                                                   | Colors.white |
| boxElevation               | Reactions box elevation                                                               | 5 |
| boxRadius                  | Reactions box radius                                                                  | 50 |
| boxPadding                 | Reactions box padding                                                                 | const EdgeInsets.all(0) |
| boxDuration                | Reactions box show/hide duration                                                      | 200 milliseconds |
| shouldChangeReaction       | Should change initial reaction after selected one or not                               | true |
| itemScale                  | Scale ratio when item hovered                                                         | 0.3 |
| itemScaleDuration          | Scale duration while dragging                                                         | const Duration(milliseconds: 100) |


## LICENSE

```legal
MIT License

Copyright (c) 2019 Abdelouahed Medjoudja

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
