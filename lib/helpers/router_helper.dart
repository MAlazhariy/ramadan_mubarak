import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:ramadan_kareem/utils/routes.dart';
import 'package:ramadan_kareem/view/screens/dashboard/dashboard_screen.dart';
import 'package:ramadan_kareem/view/screens/home/home_screen.dart';
import 'package:ramadan_kareem/view/screens/login/login_screen.dart';
import 'package:ramadan_kareem/view/screens/on_boarding/on_board_screen.dart';
import 'package:ramadan_kareem/view/screens/settings/settings_screen.dart';
import 'package:ramadan_kareem/view/screens/splash/splash_screen.dart';
import 'package:ramadan_kareem/view/widgets/screen_not_found.dart';

class RouterHelper {
  /// params handlers
  static Map<String, dynamic> getDataFrom(String data) {
    // base64url -> utf8 -> encoded json -> map
    final utf = base64Url.decode(data);
    final json = utf8.decode(utf);
    return jsonDecode(json);
  }

  static String getBase64From(Map<String, dynamic> map) {
    final json = jsonEncode(map);
    final utf = utf8.encode(json);
    return base64Url.encode(utf);
  }

  // Router
  static final FluroRouter router = FluroRouter();

  /// HANDLERS
  static final Handler _notFoundHandler = Handler(handlerFunc: (context, Map<String, List<String>> params) {
    return const ScreenNotFound();
  });

  static final Handler _splashHandler = Handler(handlerFunc: (context, Map<String, List<String>> params) {
    return const SplashScreen();
  });

  static final Handler _onBoardHandler = Handler(handlerFunc: (context, Map<String, List<String>> params) {
    return const OnBoardScreen();
  });

  static final Handler _loginHandler = Handler(handlerFunc: (context, Map<String, List<String>> params) {
    return const LoginScreen();
  });

  static final Handler _dashboardHandler = Handler(handlerFunc: (context, Map<String, List<String>> params) {
    return const DashboardScreen();
  });

  static final Handler _homeHandler = Handler(handlerFunc: (context, Map<String, List<String>> params) {
    return const HomeScreen();
  });

  static final Handler _settingsHandler = Handler(handlerFunc: (context, Map<String, List<String>> params) {
    return const SettingsScreen();
  });



  /// INIT DEFINE ROUTES
  static void init() {
    router.notFoundHandler = _notFoundHandler;
    router.define(Routes.splashScreen, handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.onBoardScreen, handler: _onBoardHandler, transitionType: TransitionType.inFromLeft);
    router.define(Routes.loginScreen, handler: _loginHandler, transitionType: TransitionType.inFromLeft);
    router.define(Routes.dashboardScreen, handler: _dashboardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.homeScreen, handler: _homeHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.settingsScreen, handler: _settingsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.blockedScreen, handler: _blockedScreenHandler, transitionType: TransitionType.native);
  }
}
