import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// [AwaitRoute] awaits the end of route enter transition animation,
/// of the [ModalRoute] tied to a [BuildContext].
///
/// Useful for views with input fields, where the auto focus should only fire
/// after the route has finished its animation.
abstract class AwaitRoute {
  static Future<ModalRoute<T>?> waitFor<T extends Object?>(
    ModalRoute<T>? route, {
    Duration timeout = const Duration(seconds: 1),
  }) {
    assert(timeout > Duration.zero);

    final animation = route?.animation;

    // Check if we can avoid listening to the animation.
    if (animation == null || animation.isCompleted) {
      return SynchronousFuture<ModalRoute<T>?>(route);
    }

    final completer = Completer<ModalRoute<T>>();
    ValueChanged<AnimationStatus>? listener;
    Timer? listenerTimeoutTimer;

    listener = (AnimationStatus status) {
      if (status == AnimationStatus.completed && !completer.isCompleted) {
        if (listenerTimeoutTimer?.isActive == true) listenerTimeoutTimer?.cancel();
        completer.complete(route);
        if (listener != null) animation.removeStatusListener(listener);
      }
    };

    listenerTimeoutTimer = Timer(timeout * timeDilation, () {
      if (listenerTimeoutTimer?.isActive == true) listenerTimeoutTimer?.cancel();
      if (listener != null) animation.removeStatusListener(listener);
      completer.complete(route);
    });

    animation.addStatusListener(listener);
    return completer.future;
  }

  static Future<ModalRoute<T>?> _awaitNow<T extends Object?>(
    BuildContext context, {
    ModalRoute<T>? route,
  }) {
    final effectiveRoute = route ?? ModalRoute.of<T>(context);
    return waitFor<T>(effectiveRoute);
  }

  static Future<ModalRoute<T>?> _awaitInPostFrame<T extends Object?>(
    BuildContext context, {
    ModalRoute<T>? route,
  }) {
    final completer = Completer<ModalRoute<T>?>();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _awaitNow<T>(context, route: route).then(completer.complete).catchError(completer.completeError));
    return completer.future;
  }

  /// Awaits the end of the [ModalRoute] enter animation.
  ///
  /// Use in [StatefulWidget.didChangeDependencies].
  static Future<ModalRoute<T>?> of<T extends Object?>(
    BuildContext context, {
    /// Await post frame, to allow this to be called from [StatefulWidget.initState].
    ///
    /// Keep in mind this leaks [BuildContext] to the next frame and is just
    /// for here for convenience prototyping.
    ///
    /// Code your widget to handle this in [StatefulWidget.didChangeDependencies].
    bool postFrame = false,

    /// The route to await. This will avoid inheriting route by the callback.
    ModalRoute<T>? route,
  }) =>
      postFrame //
          ? _awaitInPostFrame<T>(context, route: route)
          : _awaitNow<T>(context, route: route);
}

/// Extension of [BuildContext] to easily access [AwaitRoute] as a helper method.
extension AwaitContextRoute on BuildContext {
  /// Awaits the end of the [ModalRoute] enter animation
  Future<ModalRoute<T>?> awaitRoute<T extends Object?>({bool postFrame = false}) =>
      AwaitRoute.of<T>(this, postFrame: postFrame);
}
