import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:page_controller_listenable/src/page_controller_listenable.dart';

/// Returns a [PageControllerListenable], attached to the [pageController].
PageControllerListenable usePageControllerListenable(PageController pageController) =>
    use(_PageControllerListenableHook(pageController));

//

class _PageControllerListenableHook extends Hook<PageControllerListenable> {
  const _PageControllerListenableHook(this.pageController);

  final PageController pageController;

  @override
  _PageControllerListenableHookState createState() => _PageControllerListenableHookState();
}

class _PageControllerListenableHookState extends HookState<PageControllerListenable, _PageControllerListenableHook> {
  late PageControllerListenable _listenable;

  void _rebuildListenable() {
    _listenable.dispose();
    _listenable = PageControllerListenable(hook.pageController);
  }

  @override
  void initHook() {
    _listenable = PageControllerListenable(hook.pageController);
    super.initHook();
  }

  @override
  void didUpdateHook(_PageControllerListenableHook oldHook) {
    if (oldHook.pageController != hook.pageController) _rebuildListenable();
    super.didUpdateHook(oldHook);
  }

  @override
  void reassemble() {
    _rebuildListenable();
    super.reassemble();
  }

  @override
  void dispose() {
    _listenable.dispose();
    super.dispose();
  }

  @override
  PageControllerListenable build(BuildContext context) => _listenable;
}
