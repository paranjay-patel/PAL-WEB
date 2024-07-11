import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_font.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

class SaunaControlAudioTabBar extends StatefulWidget {
  final SaunaControlPopupPageStore store;
  final Function(AudioControlMenu) onTabTapped;

  const SaunaControlAudioTabBar({
    Key? key,
    required this.store,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  _SaunaControlAudioTabBarState createState() => _SaunaControlAudioTabBarState();
}

class _SaunaControlAudioTabBarState extends State<SaunaControlAudioTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();
  final tabs = [AudioControlMenu.sound, AudioControlMenu.music];
  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    if (_saunaBluetoothStore.isMusicPlaying) {
      _tabController.animateTo(tabs.indexOf(AudioControlMenu.music));
      widget.onTabTapped(AudioControlMenu.music);
    }

    reaction<AudioControlMenu>((_) => widget.store.selectedAudioControlMenu, (selectedAudioControlMenu) {
      if (selectedAudioControlMenu == AudioControlMenu.sound) {
        _tabController.animateTo(AudioControlMenu.values.indexOf(selectedAudioControlMenu));
      }
    }).disposeWith(_reaction);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return UnconstrainedBox(
      child: Container(
        height: Utils.getScreenSize(context).getFontSize(min: 60, max: 72),
        width: 500,
        alignment: Alignment.center,
        child: TabBar(
          isScrollable: true,
          controller: _tabController,
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          labelColor: ThemeColors.blue50,
          indicatorColor: ThemeColors.blue50,
          labelStyle: TextStyle(
            fontSize: Utils.getScreenSize(context).getFontSize(min: 16, max: 24),
            fontWeight: FontWeight.bold,
            fontFamily: ThemeFont.defaultFontFamily,
          ),
          unselectedLabelColor: theme.tabBarUnselectedColor,
          indicatorWeight: 3,
          dividerColor: Colors.transparent,
          onTap: (index) {
            widget.onTabTapped(tabs[index]);
          },
          tabs: tabs.map((tab) {
            return Tab(
              child: Observer(builder: (context) {
                final isMusicPlaying = _saunaBluetoothStore.isMusicPlaying;
                return Row(
                  children: [
                    if (tab == AudioControlMenu.music && isMusicPlaying)
                      Assets.activeSound.toSvgPicture(
                        width: 25,
                        height: 25,
                      ),
                    Text(
                      tab.tabTitle,
                      style: TextStyle(
                        fontSize: Utils.getScreenSize(context).getFontSize(min: 16, max: 24),
                        fontWeight: FontWeight.bold,
                        fontFamily: ThemeFont.defaultFontFamily,
                      ),
                    ),
                  ],
                );
              }),
            );
          }).toList(),
        ),
      ),
    );
  }
}
