import 'dart:async';

import 'package:flutter/foundation.dart';

/// Debounces rapid callbacks (e.g. search input) to a single trailing call.
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 400)});

  final Duration delay;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
