import 'package:flutter/cupertino.dart';

class CustomCupertinoPageRoute extends CupertinoPageRoute {
  CustomCupertinoPageRoute({
    required WidgetBuilder builder,
    String? title,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            title: title,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);
}
