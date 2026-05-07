import 'dart:js' as js;
import 'dart:js_util' as jsu;

Future<void> installPwa() async {
  try {
    final ok = await jsu.promiseToFuture<bool>(js.context.callMethod('installPWA', []));
    if (ok) {
      print("PWA installed successfully");
    }
  } catch (e) {
    print("Error installing PWA: $e");
  }
}