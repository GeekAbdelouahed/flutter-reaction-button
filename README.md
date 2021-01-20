# Flutter Reaction Button

[![pub package](https://img.shields.io/pub/v/flutter_reaction_button.svg)](https://pub.dartlang.org/packages/flutter_reaction_button)

Flutter button reaction it is fully customizable widget such as Facebook reaction button.

## Preview

<img src="https://github.com/GeekAbdelouahed/flutter-reaction-button/raw/master/images/Preview.png"/>

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
import 'package:flutter_places/flutter_reaction_button.dart';
```

## Examples

# flutter_reaction_button

This is example Flutter Reaction Button Check:

<img src="https://github.com/GeekAbdelouahed/flutter-reaction-button/raw/master/images/Flutter-Reaction-Button-Check.gif"/>

```dart
FlutterReactionButtonCheck(
    onReactionChanged: (reaction, index, isChecked) {
        print('reaction selected index: $index');
    },
    reactions: <Reaction>[
        Reaction(
            previewIcon: buildWidgetPreview(
                icon: 'like.gif',
            ),
            icon: buildWidget(
                icon: 'like_fill.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                icon: 'love.gif',
            ),
            icon: buildWidget(
                icon: 'love.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                icon: 'wow.gif',
            ),
            icon: buildWidget(
                icon: 'wow.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                icon: 'haha.gif',
            ),
            icon: buildWidget(
                icon: 'haha.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                icon: 'sad.gif',
            ),
            icon: buildWidget(
                icon: 'sad.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                icon: 'angry.gif',
            ),
            icon: buildWidget(
                icon: 'angry.png'
            ),
        ),
    ],
    initialReaction: Reaction(
        icon: buildWidget(
            icon: 'like.png'
        ),
    ),
    selectedReaction: Reaction(
        icon: buildWidget(
            icon: 'like_fill.png'
        ),
    ),
)
```



This is a example Flutter Reaction Button:

<img src="https://github.com/GeekAbdelouahed/flutter-reaction-button/raw/master/images/Flutter-Reaction-Button.gif"/>

```dart
FlutterReactionButton(
    onReactionChanged: (reaction, index) {
        print('reaction selected index: $index');
    },
    reactions: <Reaction>[
        Reaction(
            previewIcon: buildWidgetPreview(
                title: 'English',
                icon: 'united-kingdom-round.png',
            ),
            icon: buildWidget(
                icon: 'united-kingdom.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                title: 'Arabic',
                icon: 'algeria-round.png',
            ),
            icon: buildWidget(
                icon: 'algeria.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                title: 'German',
                icon: 'germany-round.png',
            ),
            icon: buildWidget(
                icon: 'germany.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                title: 'Spanish',
                icon: 'spain-round.png',
            ),
            icon: buildWidget(
                icon: 'spain.png'
            ),
        ),
        Reaction(
            previewIcon: buildWidgetPreview(
                title: 'Chinese',
                icon: 'china-round.png',
            ),
            icon: buildWidget(
                icon: 'china.png'
            ),
        ),
    ],
    initialReaction: Reaction(
        previewIcon: buildWidgetPreview(
            title: 'English',
            icon: 'united-kingdom-round.png',
        ),
        icon: buildWidget(
            icon: 'united-kingdom.png'
        ),
    ),
)
```

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
