import 'dart:async';
import 'package:get/get.dart';

/// A search worker whose owner also cancels an already queued callback.
/// Keeps GetX stream delivery and trailing-edge delay semantics unchanged.
Worker ownedDebounce<T>(
  RxInterface<T> source,
  void Function(T) callback, {
  required Duration time,
}) {
  Timer? timer;
  var closed = false;
  final subscription = source.listen((event) {
    if (closed) return;
    timer?.cancel();
    timer = Timer(time, () {
      if (!closed) callback(event);
    });
  });
  return Worker(() async {
    closed = true;
    timer?.cancel();
    await subscription.cancel();
  }, '[ownedDebounce]');
}
