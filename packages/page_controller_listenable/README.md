# Page Controller Listenable

A listenable that wraps around the `PageController`.

This listenable extends `ValueListenable<double>` and can be quickly passed into animations, where the type check would fail against the `PageController`.

## Example

```dart
class ExampleWidgetState extends State<ExampleWidget> {
  late PageController _pageController;
  late PageControllerListenable _pageControllerListenable;

  @override
  void initState() {
    _pageController = PageController();
    _pageControllerListenable = PageControllerListenable(_pageController);
    super.initState();
  }

  @override
  void dispose() {
    _pageControllerListenable.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWithSomeAnimation(
      animation: _pageControllerListenable,
      child: ...
    );
  }
}
```

There's a hook included too.

## Hook example

```dart
class ExampleWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final pageControllerListenable = usePageControllerListenable(pageController);

    return WidgetWithSomeAnimation(
      animation: pageControllerListenable,
      child: ...
    );
  }
}
```
