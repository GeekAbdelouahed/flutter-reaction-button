import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button/src/widgets/reactions_box.dart';
import 'package:flutter_reaction_button/src/widgets/reactions_box_item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'main.dart';

void main() {
  group(
    'Reaction button with toggle = true',
    () {
      testWidgets(
        'Expect to select initial reaction '
        'when tap on reaction button',
        (tester) async {
          await tester.pumpWidget(const MyApp());
          final Finder reaction = find.byType(ReactionButton).first;
          await tester.tap(reaction);
          await tester.pump();
          final Finder initialReaction = find.byIcon(Icons.ac_unit);
          expect(initialReaction, findsOneWidget);
        },
      );

      testWidgets(
        'Expect to show reactions box '
        'when long press on reaction button',
        (tester) async {
          await tester.pumpWidget(const MyApp());
          final Finder reaction = find.byType(ReactionButton).first;
          await tester.longPress(reaction);
          await tester.pumpAndSettle();
          final Finder reactionsBox = find.byType(ReactionsBox);
          expect(reactionsBox, findsOneWidget);
        },
      );

      testWidgets(
        'Expect reactions box to closed successfully '
        'when tap outside',
        (tester) async {
          await tester.pumpWidget(const MyApp());
          final Finder reaction = find.byType(ReactionButton).first;
          await tester.longPress(reaction);
          await tester.pumpAndSettle();
          final Finder outsideWidget = find.byKey(const ValueKey('outside'));
          await tester.tap(outsideWidget);
          await tester.pumpAndSettle();
          final Finder lastReactionIcon = find.byType(ReactionsBox);
          expect(lastReactionIcon, findsNothing);
        },
      );

      testWidgets(
        'Expect to select last reaction from reactions box '
        'when long press on reaction button and reactions box is visible',
        (tester) async {
          await tester.pumpWidget(const MyApp());
          final Finder reaction = find.byType(ReactionButton).first;
          await tester.longPress(reaction);
          await tester.pumpAndSettle();
          final Finder lastReaction = find.byType(ReactionsBoxItem).last;
          await tester.tap(lastReaction);
          await tester.pumpAndSettle();
          final Finder lastReactionIcon = find.byIcon(Icons.wind_power);
          expect(lastReactionIcon, findsOneWidget);
        },
      );
    },
  );

  group(
    'Reaction button with toggle = false',
    () {
      testWidgets(
        'Expect to show reactions box '
        'when tap on reaction button',
        (tester) async {
          await tester.pumpWidget(const MyApp(toggle: false));
          final Finder reaction = find.byType(ReactionButton).first;
          await tester.tap(reaction);
          await tester.pumpAndSettle();
          final Finder reactionsBox = find.byType(ReactionsBox);
          expect(reactionsBox, findsOneWidget);
        },
      );

      testWidgets(
        'Expect reactions box to closed successfully '
        'when tap outside',
        (tester) async {
          await tester.pumpWidget(const MyApp(toggle: false));
          final Finder reaction = find.byType(ReactionButton).first;
          await tester.tap(reaction);
          await tester.pumpAndSettle();
          final Finder outsideWidget = find.byKey(const ValueKey('outside'));
          await tester.tap(outsideWidget);
          await tester.pumpAndSettle();
          final Finder lastReactionIcon = find.byType(ReactionsBox);
          expect(lastReactionIcon, findsNothing);
        },
      );

      testWidgets(
        'Expect to select last reaction from reactions box '
        'when long press on reaction button and reactions box is visible',
        (tester) async {
          await tester.pumpWidget(const MyApp(toggle: false));
          final Finder reaction = find.byType(ReactionButton).first;
          await tester.tap(reaction);
          await tester.pumpAndSettle();
          final Finder lastReaction = find.byType(ReactionsBoxItem).last;
          await tester.tap(lastReaction);
          await tester.pumpAndSettle();
          final Finder lastReactionIcon = find.byIcon(Icons.wind_power);
          expect(lastReactionIcon, findsOneWidget);
        },
      );
    },
  );
}
