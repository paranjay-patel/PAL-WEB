import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' as pr;
import 'package:provider/provider.dart';

class MobxProvider<T extends Disposable?> extends pr.Provider<T> {
  static void _dispose(BuildContext context, Disposable? store) {
    store?.dispose();
  }

  MobxProvider({
    Key? key,
    required pr.Create<T> create,
    bool? lazy,
    Widget? child,
  }) : super(
          key: key,
          lazy: lazy,
          create: create,
          dispose: _dispose,
          child: child,
        );

  /// Defaults to `(previous, next) => previous != next`.
  /// See [InheritedWidget.updateShouldNotify] for more information.
  MobxProvider.value({
    Key? key,
    required T value,
    pr.UpdateShouldNotify<T>? updateShouldNotify,
    Widget? child,
  }) : super.value(
          key: key,
          value: value,
          updateShouldNotify: updateShouldNotify,
          child: child,
        );
}

mixin Disposable {
  void dispose() {}
}

extension WatchOrNull on BuildContext {
  T? watchOrNull<T>() {
    try {
      return watch<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    }
  }

  T? readOrNull<T>() {
    try {
      return read<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    }
  }
}
