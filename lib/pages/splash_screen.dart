import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _reaction = CompositeReactionDisposer();
  final audioPlayerStore = locator<AudioPlayerStore>();

  @override
  void initState() {
    super.initState();

    reaction((_) => audioPlayerStore.isBootUpFinished, (bool isBootUpFinished) async {
      if (isBootUpFinished) {
        Navigator.pushNamed(context, RouteGenerator.saunaHomePage);
      }
    }, fireImmediately: true)
        .disposeWith(_reaction);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.splashBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).colorScheme.splashBackgroundGradientColors,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: screenSize.getHeight(min: 260, max: 360),
                width: screenSize.getHeight(min: 260, max: 360),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenSize.getHeight(min: 50, max: 80)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: Theme.of(context).colorScheme.backgroundGradientColors,
                  ),
                  boxShadow: theme.saunaSlashIconShadow,
                ),
                child: SizedBox(
                  height: screenSize.getHeight(min: 200, max: 280),
                  width: screenSize.getHeight(min: 200, max: 280),
                  child: Assets.splashLogo.toSvgPicture(),
                ),
              ),
              SizedBox(height: screenSize.getHeight(min: 40, max: 60)),
              Text(
                'Welcome to Found—Space'.toUpperCase(),
                style: TextStyle(
                  color: theme.splashTitleText,
                  fontWeight: FontWeight.normal,
                  fontSize: screenSize.getFontSize(min: 20, max: 24),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
