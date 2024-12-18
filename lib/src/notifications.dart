import 'package:flutter/widgets.dart';

/// A widget which can dispatch notifications to a group of [Slidable] below it.
class SlidableGroupBehavior<T> extends StatefulWidget {
  /// Callback that can modified a notification before to be dispatched to
  /// listeners.
  ///
  /// If the result if null, then the notitication is not dispatched.
  final T? Function(T notification)? onNotification;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Creates a SlidableGroupBehavior.
  const SlidableGroupBehavior({
    super.key,
    this.onNotification,
    required this.child,
  });

  @override
  _SlidableGroupBehaviorState<T> createState() =>
      _SlidableGroupBehaviorState<T>();
}

/// A widget which listens to notifications dispatched by a
/// [SlidableGroupBehavior] of the same type.
///
/// Typically this widget is a child of a [Slidable] widget.
class SlidableGroupBehaviorListener<T> extends StatefulWidget {
  /// The callback to invoke when a notification is dispatched.
  final ValueChanged<T> onNotification;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Creates a [SlidableGroupBehaviorListener].
  const SlidableGroupBehaviorListener({
    super.key,
    required this.onNotification,
    required this.child,
  });

  @override
  State<SlidableGroupBehaviorListener<T>> createState() =>
      _SlidableGroupBehaviorListenerState<T>();
}

/// Used to dispatch a Slidable notification.
class SlidableGroupNotification {
  const SlidableGroupNotification._();

  /// Creates a dispatcher used to dispatch the [notification] to the closest
  /// [SlidableGroupBehavior] with the given type.
  ///
  /// [assertParentExists] is only used internally to not throws an assertion
  /// error if there are no [SlidableGroupBehavior]s in the tree.
  ///
  /// It can be useful to call this method instead of [dispatch] in case you
  /// want to send a last notification before disposing a StatefulWidget.
  static SlidableGroupNotificationDispatcher<T>? createDispatcher<T>(
    BuildContext context, {
    bool assertParentExists = true,
  }) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            _InheritedSlidableNotification<T>>()
        ?.widget as _InheritedSlidableNotification<T>?;

    assert(() {
      if (assertParentExists && widget == null) {
        throw FlutterError(
          'SlidableGroupBehavior.of<$T> called with a context that '
          'does not contain a SlidableGroupBehavior<$T>.',
        );
      }
      return true;
    }());
    if (widget != null) {
      return SlidableGroupNotificationDispatcher<T>._(widget);
    }

    return null;
  }

  /// Dispatches the [notification] to the closest [SlidableGroupBehavior] with
  /// the given type.
  ///
  /// [assertParentExists] is only used internally to not throws an assertion
  /// error if there are no [SlidableGroupBehavior]s in the tree.
  static void dispatch<T>(
    BuildContext context,
    T notification, {
    bool assertParentExists = true,
  }) {
    final dispatcher = createDispatcher<T>(
      context,
      assertParentExists: assertParentExists,
    );
    dispatcher?.dispatch(notification);
  }
}

/// A dispatcher used to dispatch a Slidable notification.
class SlidableGroupNotificationDispatcher<T> {
  final _InheritedSlidableNotification<T> _inheritedSlidableNotification;
  SlidableGroupNotificationDispatcher._(this._inheritedSlidableNotification);

  /// Dispatches the [notification] to the closest [SlidableGroupBehavior] with
  /// the given type.
  ///
  /// [assertParentExists] is only used internally to not throws an assertion
  /// error if there are no [SlidableGroupBehavior]s in the tree.
  void dispatch(T notification) {
    final notifier = _inheritedSlidableNotification.notifier;
    final onNotification = _inheritedSlidableNotification.onNotification;
    final effectiveNotification =
        onNotification != null ? onNotification(notification) : notification;

    if (effectiveNotification != null) {
      notifier.value = effectiveNotification;
    }
  }
}

class _InheritedSlidableNotification<T> extends InheritedWidget {
  final T? Function(T notification)? onNotification;
  final ValueNotifier<T?> notifier;

  const _InheritedSlidableNotification({
    required this.onNotification,
    required this.notifier,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedSlidableNotification<T> oldWidget) {
    return oldWidget.notifier != notifier;
  }

  static ValueNotifier<T?>? of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedSlidableNotification<T>>()
        ?.notifier;
  }
}

class _SlidableGroupBehaviorListenerState<T>
    extends State<SlidableGroupBehaviorListener<T>> {
  ValueNotifier<T?>? notifier;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final oldNotifier = notifier;
    final newNotifier = _InheritedSlidableNotification.of<T>(context);
    if (oldNotifier != newNotifier) {
      if (oldNotifier != null) {
        oldNotifier.removeListener(handleNotification);
      }
      if (newNotifier != null) {
        newNotifier.addListener(handleNotification);
      }
      notifier = newNotifier;
    }
  }

  @override
  void dispose() {
    notifier?.removeListener(handleNotification);
    super.dispose();
  }

  void handleNotification() {
    final notification = notifier?.value;
    if (notification != null) {
      widget.onNotification(notification);
    }
  }
}

class _SlidableGroupBehaviorState<T> extends State<SlidableGroupBehavior<T>> {
  final valueNotifier = ValueNotifier<T?>(null);

  @override
  Widget build(BuildContext context) {
    return _InheritedSlidableNotification(
      onNotification: widget.onNotification,
      notifier: valueNotifier,
      child: widget.child,
    );
  }
}
