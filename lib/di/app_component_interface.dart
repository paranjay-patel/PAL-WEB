import 'package:found_space_flutter_web_application/app_startup/app_flavor.dart';

/// This is the app component, which is the dependency container for repository,
/// database, network client, shared pref, etc objects
///
/// Please pay attention that the implementations provided here must include the
/// buildVariant from [AppConfig] for pages that are different in m1 app and full app
/// Please check [UserRepository getUserRepository()] here
///
class AppComponentBase {
  static late AppFlavor _appFlavor;

  static AppFlavor get flavor => _appFlavor;

  static setupAppComponentBase(AppFlavor appFlavor) {
    _appFlavor = appFlavor;
  }

  static bool get isReleaseBuild => AppComponentBase.flavor == AppFlavor.white;

  static bool get isAutomationBuild => AppComponentBase.flavor == AppFlavor.red;
}
