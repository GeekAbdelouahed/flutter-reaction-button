# Flutter Reaction Button

Flutter button reaction it is fully customizable widget such as Facebook reaction button.

- [Pub Package](https://pub.dartlang.org/packages/flutter-reaction-button)
- [GitHub Repository](https://github.com/GeekAbdelouahed/flutter-reaction-button)
- [API reference](https://pub.dartlang.org/documentation/flutter-reaction-button/)

## Usage

This is example Flutter Reaction Button:

```dart
FlutterReactionButton(
    onReactionChanged: (isChecked, reaction) {
        print('reaction changed');
    },
    reactions: <Reaction>[
        Reaction(
            previewIcon: Text('U.Kingdom'),
            icon: Text('UK'),
        ),
        Reaction(
            previewIcon: Text('Algeria'),
            icon: Text('DZ'),
        ),
        Reaction(
            previewIcon: Text('Germany'),
            icon: Text('GR'),
        ),
    ],
    initialReaction: Reaction(
            previewIcon: Text('U.Kingdom'),
            icon: Text('UK'),
    ),
    selectedReaction: Reaction(
            previewIcon: Text('U.Kingdom'),
            icon: Text('UK'),
    ),
    radius: 10,
    elevation: 10,
    position: Position.TOP,
    color: Colors.black.withOpacity(0.5),
    duration: Duration(milliseconds: 500),
)
```
<img src="images/Flutter-Reaction-Button.gif"/>

This is a example Flutter Reaction Button Check:

```dart
FlutterReactionButtonCheck(
    onReactionChanged: (reaction) {
        print('reaction changed');
    },
    reactions: <Reaction>[
        Reaction(
            previewIcon: Text('U.Kingdom'),
            icon: Text('UK'),
        ),
        Reaction(
            previewIcon: Text('Algeria'),
            icon: Text('DZ'),
        ),
        Reaction(
            previewIcon: Text('Germany'),
            icon: Text('GR'),
        ),
    ],
    initialReaction: Reaction(
            previewIcon: Text('Default'),
            icon: Text('DF'),
    ),
    selectedReaction : Reaction(
            previewIcon: Text('U.Kingdom'),
            icon: Text('UK'),
    ),
    radius: 10,
    elevation: 10,
    position: Position.TOP,
    color: Colors.black.withOpacity(0.5),
    duration: Duration(milliseconds: 500),
)
```

<img src="images/Flutter-Reaction-Button-Check.gif"/>

For more information about the properties, have a look at the [API reference](https://pub.dartlang.org/documentation/flutter-reaction-button/).

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
