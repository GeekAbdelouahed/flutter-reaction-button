# flutter_reaction_button_example

ReactionButton:

```dart
ReactionButton<String>(
    onReactionChanged: (Reaction<String>? reaction) {
        debugPrint('Selected value: ${reaction?.value}');
    },
    reactions: <Reaction<String>>[
        Reaction<String>(
            value: 'like',
            icon: widget,
        ),
        Reaction<String>(
            value: 'love',
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
ReactionButton<String>(
    toggle: false,
    onReactionChanged: (Reaction<String>? reaction) {
        debugPrint('Selected language: ${reaction?.value}');
    },
    reactions: <Reaction<String>>[
        Reaction<String>(
            value: 'en',
            icon: widget,
        ),
        Reaction<String>(
            value: 'ar',
            icon: widget,
        ),
        ...
    ],
    initialReaction: Reaction<String>(
        value: null,
        icon: Icon(Icons.language),
    ),
)
```