import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/src/chameleon_theme/adaptive_chameleon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_color_theme_utils.dart';

class SaunaColorThemeControl extends StatelessWidget {
  final SaunaControlPopupPageStore store;
  const SaunaColorThemeControl({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context,
                SaunaColorThemeModeType.light,
              ),
              SizedBox(width: screenSize.getWidth(min: 30, max: 52)),
              _buildButton(
                context,
                SaunaColorThemeModeType.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, SaunaColorThemeModeType type) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (_) {
        final isSelected = store.saunaColorThemeModeType == type;
        return FeedbackSoundWrapper(
          onTap: () {
            final isNightMode = type.isNightMode;
            AdaptiveChameleonTheme.of(context).changeThemeMode(dark: isNightMode);
            store.setSaunaColorThemeModeType(type);
          },
          child: SizedBox(
            height: screenSize.getHeight(min: 200, max: 260),
            width: screenSize.getWidth(min: 260, max: 320),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: type == SaunaColorThemeModeType.light ? ThemeColors.orange10 : null,
                      gradient: type == SaunaColorThemeModeType.light
                          ? null
                          : const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF363944),
                                Color(0xFF090A0B),
                              ],
                            ),
                      border: isSelected
                          ? Border.all(
                              color: ThemeColors.blue50,
                              width: 3,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      type.image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  type.title,
                  style: TextStyle(
                    color: theme.titleTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: screenSize.getFontSize(min: 14, max: 20),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Opacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: ThemeColors.blue50,
                      fontWeight: FontWeight.w600,
                      fontSize: screenSize.getFontSize(min: 10, max: 16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
