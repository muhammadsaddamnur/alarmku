import 'dart:async';

class ServiceDebounce {
  ///timer for debounce
  ///
  static Timer? debounce;

  static call(
      {Function? function,
      Duration duration = const Duration(milliseconds: 200)}) async {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(duration, () {
      function!();
      debounce!.cancel();
    });
  }
}
