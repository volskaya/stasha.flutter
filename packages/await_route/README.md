# Await Route

Convenience helper for awaiting route animation to finish.

This allows animating in keyboards, when a page with a form is opened, or deferring expensive animations and other work.

## Example

```dart
class ExampleWidgetState extends State<ExampleWidget> {
  var _didHandleInitialDependencies = false;

  @override
  void didChangeDependencies() {
    if (_didHandleInitialDependencies) return;

    // Focuses first input field and opens the keyboard, after the route has
    // finished animation.
    AwaitRoute.of(context).then(() => focusKeyboardOrSomething());
  }
}
```
