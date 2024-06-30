This is a Flutter widget to transform sliver widgets, the same way one would transform box widgets.

```dart
/// This example widget applies offset to the sliver under it.
final exampleWidget = CustomScrollView(
  slivers: [
    SliverTransform.translate(
      offset: const Offset(0.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Container(),
        ]),
      ),
    ),
  ],
);
```
