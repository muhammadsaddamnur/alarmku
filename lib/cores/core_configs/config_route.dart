import 'package:alarmku/features/clock/views/clock_view.dart';
import 'package:get/get.dart';

class ConfigRoute {
  ///initial route
  ///
  static String initialRoute() => '/';

  ///list of route
  ///
  static List<GetPage>? route() {
    return [
      GetPage(
        name: '/',
        page: () => const ClockView(),
      ),
    ];
  }
}
