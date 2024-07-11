import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_font.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:mobx/mobx.dart';

class SaunaAdvanceSettingsTabBar extends StatefulWidget {
  final SaunaControlPopupPageStore store;
  final Function(SaunaAdvanceSettingsTabType) onTabTapped;

  const SaunaAdvanceSettingsTabBar({
    Key? key,
    required this.store,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  _SaunaAdvanceSettingsTabBarState createState() => _SaunaAdvanceSettingsTabBarState();
}

class _SaunaAdvanceSettingsTabBarState extends State<SaunaAdvanceSettingsTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: SaunaAdvanceSettingsTabType.values.length, vsync: this);

    reaction<SaunaAdvanceSettingsTabType>((_) => widget.store.selectedAdvanceSettingsTabType,
        (selectedAdvanceSettingsTabType) {
      if (selectedAdvanceSettingsTabType == SaunaAdvanceSettingsTabType.general) {
        _tabController.animateTo(SaunaAdvanceSettingsTabType.values.indexOf(selectedAdvanceSettingsTabType));
      }
    }).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);
    return Container(
      height: screenSize.getHeight(min: 52, max: 64),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.lightTabBarBackgroundColor,
        borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
        boxShadow: theme.innerPageViewShadow,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: theme.lightTabBackgroundColor,
          boxShadow: theme.saunaControlPageButtonShadow,
        ),
        padding: EdgeInsets.all(screenSize.getHeight(min: 6, max: 8)),
        labelStyle: TextStyle(
          fontSize: Utils.getScreenSize(context).getFontSize(min: 14, max: 20),
          fontWeight: FontWeight.w500,
          fontFamily: ThemeFont.defaultFontFamily,
        ),
        labelColor: theme.iconColor,
        unselectedLabelColor: theme.iconColor,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        onTap: (index) {
          widget.onTabTapped(SaunaAdvanceSettingsTabType.values[index]);
        },
        tabs: SaunaAdvanceSettingsTabType.values.map((tab) {
          return Tab(
            text: tab.title,
          );
        }).toList(),
      ),
    );
  }
}
