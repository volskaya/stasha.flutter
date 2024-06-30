import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Attaches a [ChangeNotifier] to a [PageController], where the value will be the
/// page controller's page.
///
/// Call [dispose] when the notifier won't be used anymore.
class PageControllerListenable extends ChangeNotifier implements ValueListenable<double> {
  PageControllerListenable(this._pageController) {
    _pageController.addListener(notifyListeners);
  }

  final PageController _pageController;

  double? get page => _pageController.page;
  int get initialPage => _pageController.initialPage;

  @override
  get value => page ?? 0.0;

  @override
  void dispose() {
    _pageController.removeListener(notifyListeners);
    super.dispose();
  }
}
