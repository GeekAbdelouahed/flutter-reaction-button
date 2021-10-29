# flutter_reaction_button_example

ReactionButtonToggle:

```dart
ReactionButtonToggle<String>(
    onReactionChanged: (String? value, bool isChecked) {
        print('Selected value: $value, isChecked: $isChecked');
    },
    reactions: <Reaction<String>>[
        Reaction<String>(
            value: 'like',
            previewIcon: widget,
            icon: widget,
        ),
        Reaction<String>(
            value: 'love',
            previewIcon: widget,
            icon: widget,
        ),
        ...
    ],
    initialReaction: Reaction<String>(
        value: 'like',
        icon: widget,
    ),
    selectedReaction: Reaction<String>(
        value: 'like_fill',
        icon: widget,
    ),
)
```


ReactionButton:

```dart
ReactionButton<String(
    onReactionChanged: (String? value) {
        print('Selected value: $value');
    },
    reactions: <Reaction<String>>[
        Reaction<String>(
            value: 'en',
            previewIcon: widget,
            icon: widget,
        ),
        Reaction<String>(
            value: 'ar',
            previewIcon: widget,
            icon: widget,
        ),
        ...
    ],
    initialReaction: Reaction<String>(
        value: null,
        icon: Icon(
            Icons.language,
        ),
    ),
)
```