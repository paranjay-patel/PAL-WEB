import 'dart:async';
import 'package:rxdart/rxdart.dart';

extension StreamSubscriptionExtensions on StreamSubscription {
  void disposeWith(CompositeSubscription subscriptions) {
    subscriptions.add(this);
  }
}

extension IterableExtension<E> on Iterable<E> {
  Iterable<T> mapWithIndex<T>(T Function(E e, int index) f) {
    var index = -1;
    return map((item) {
      return f(item, ++index);
    });
  }

  Iterable<E> orderBy<G extends Comparable<G>>(G Function(E a) f, {bool decending = false}) {
    final sortedItem = toList()..sort((a, b) => decending ? f(b).compareTo(f(a)) : f(a).compareTo(f(b)));
    return sortedItem.map((item) => item);
  }

  void forEachWithIndex(void Function(E e, int index) f) {
    var index = -1;
    return forEach((item) {
      f(item, ++index);
    });
  }
}
