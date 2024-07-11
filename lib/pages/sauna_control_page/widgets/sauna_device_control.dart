import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/models.dart' hide State;
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/found_space_constants.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/measurer.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/di/app_component_interface.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/pages/sauna_security_pin/store/sauna_security_pin_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:mobx/mobx.dart';

class SaunaDeviceControl extends StatefulWidget {
  const SaunaDeviceControl({Key? key}) : super(key: key);

  @override
  State<SaunaDeviceControl> createState() => _SaunaDeviceControlState();
}

class _SaunaDeviceControlState extends State<SaunaDeviceControl> with TickerProviderStateMixin {
  late ScreenSize _screenSize;
  late AnimationController _animationController;
  late Animation _animation;
  final _saunaStore = locator<SaunaStore>();
  final _compositeReaction = CompositeReactionDisposer();

  late ScreenSaverStore _screenSaverStore;

  Size _imageSize = const Size(200, 200);

  @override
  void initState() {
    super.initState();
    _initAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reaction(
        (_) => _saunaStore.saunaState,
        (SaunaState saunaState) {
          final saunaDeviceShadow = saunaState.getShadowColor(context);
          if (saunaDeviceShadow.canGlow) {
            _animationController.repeat(reverse: true);
          } else {
            _animationController.stop();
          }
        },
        fireImmediately: true,
      ).disposeWith(_compositeReaction);
    });

    _screenSaverStore = context.read<ScreenSaverStore>();
  }

  @override
  void dispose() {
    _compositeReaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = Utils.getScreenSize(context);

    return Expanded(
      child: Observer(
        builder: (_) {
          final saunaState = _saunaStore.saunaState;
          final stateButtons = saunaState.getStateTypes;
          final saunaStateShadow = saunaState.getShadowColor(context);
          final isSettingsMenuSelected = _saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
          final panelImage = _saunaStore.panelImage;
          final deviceToken = _saunaStore.deviceToken;

          return Row(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  if (_saunaStore.selectedSaunaMenuType == SaunaMenuType.saunaControl) return;
                  _saunaStore.setPopupType(type: PopupType.none);
                  _saunaStore.setSelectedMenuType(SaunaMenuType.saunaControl);
                  context.read<ScreenSaverStore>().setupScreenSaverTimer();
                },
                behavior: HitTestBehavior.opaque,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    height: _screenSize.getHeight(min: 240, max: 300),
                    width: _screenSize.getHeight(min: 240, max: 300),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildFirmwareUpdateInfoSection(),
                    if (AppComponentBase.isAutomationBuild)
                      const Expanded(child: SizedBox())
                    else
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (panelImage.isNotEmpty && deviceToken != null && deviceToken.isNotEmpty)
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (_, child) {
                                  return Container(
                                    width: _imageSize.width <= 0.0
                                        ? 0.0
                                        : _imageSize.width -
                                            (_screenSize == ScreenSize.small
                                                ? 160
                                                : _screenSize.getWidth(min: 115, max: 124)),
                                    height: _imageSize.height <= 0.0
                                        ? 0.0
                                        : _imageSize.height - _screenSize.getHeight(min: 70, max: 80),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 80, max: 100)),
                                      boxShadow: saunaStateShadow.hasShadow
                                          ? [
                                              BoxShadow(
                                                color: saunaStateShadow.color.withOpacity(
                                                  saunaStateShadow.canGlow
                                                      ? _animation.value < 10
                                                          ? _animation.value / 30
                                                          : .6
                                                      : .6,
                                                ),
                                                spreadRadius: saunaStateShadow.canGlow ? _animation.value / 2.25 : 30,
                                                blurRadius: saunaStateShadow.canGlow ? _animation.value : 100,
                                                offset: Offset.zero,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Image.network(
                                      panelImage,
                                      fit: BoxFit.fill,
                                      headers: {FoundSpaceConstants.authorizationHeaderKey: deviceToken},
                                    ),
                                  );
                                },
                              ),
                            if (panelImage.isNotEmpty && deviceToken != null && deviceToken.isNotEmpty)
                              Measurer(
                                onMeasure: (size, constraints) {
                                  setState(() {
                                    _imageSize = size ?? const Size(200, 200);
                                  });
                                },
                                child: Image.network(
                                  panelImage,
                                  fit: BoxFit.contain,
                                  headers: {FoundSpaceConstants.authorizationHeaderKey: deviceToken},
                                ),
                              ),
                          ],
                        ),
                      ),
                    SizedBox(height: _screenSize.getHeight(min: 16, max: 24)),
                    _buildSaunaStatusText(),
                    SizedBox(height: _screenSize.getHeight(min: 20, max: 30)),
                    _buildProgramModifiedSection(),
                    if (isSettingsMenuSelected)
                      _buildFirmwareVersionButton()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: stateButtons
                            .map((type) => _buildDeviceStateButton(type, saunaState, saunaState.color))
                            .toList(),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onDoubleTap: () async {
                  if (_saunaStore.selectedSaunaMenuType == SaunaMenuType.settings) return;
                  _saunaStore.setPopupType(type: PopupType.none);
                  _saunaStore.setSelectedMenuType(SaunaMenuType.settings);
                  if (locator<SaunaLocalStorageStore>().isSecuritySettingsEnabled) {
                    context.read<ScreenSaverStore>().cancelScreenSaverTimer();
                    await Future.delayed(const Duration(milliseconds: 250));
                    final status = await Navigator.pushNamed(
                      context,
                      RouteGenerator.saunaSecurityPinPage,
                      arguments: SaunaSecurityPinPageState.verifySettings,
                    ) as bool?;

                    if (status == null) {
                      _saunaStore.setSelectedMenuType(SaunaMenuType.saunaControl);
                    }
                  }
                  context.read<ScreenSaverStore>().setupScreenSaverTimer();
                },
                behavior: HitTestBehavior.opaque,
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: _screenSize.getHeight(min: 240, max: 300),
                    width: _screenSize.getHeight(min: 240, max: 300),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgramModifiedSection() {
    final theme = Theme.of(context).colorScheme;
    return Observer(builder: (context) {
      final width = _screenSize.getWidth(min: 230, max: 300);
      final height = _screenSize.getHeight(min: 46, max: 68);
      final isSettingsMenuSelected = _saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
      final showProgramModifiedSection = _saunaStore.programChangedIndicatorsAreEnabled && !isSettingsMenuSelected;

      return AnimatedContainer(
        height: showProgramModifiedSection ? height + _screenSize.getHeight(min: 16, max: 26) : 0.0,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
          visible: showProgramModifiedSection,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: _screenSize.getHeight(min: 16, max: 26)),
            child: Container(
              height: height,
              width: (width * 2) + _screenSize.getHeight(min: 8, max: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 6, max: 12)),
                border: Border.all(color: theme.programModifiedSectionBorderColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: _screenSize.getHeight(min: 14, max: 24)),
                  Text(
                    'Program has been modified',
                    key: const Key('program_modified'),
                    style: TextStyle(
                      fontSize: _screenSize.getFontSize(min: 14, max: 20),
                      fontWeight: FontWeight.w600,
                      color: theme.programModifiedTextColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const Spacer(),
                  _Button(
                    key: const Key('button_reset_key'),
                    buttonText: 'Reset',
                    height: height,
                    width: height + _screenSize.getHeight(min: 6, max: 10),
                    onTap: () async {
                      if (_saunaStore.isResettingProgram) return;
                      await _saunaStore.resetModifiedProgram();
                    },
                  ),
                  SizedBox(width: _screenSize.getHeight(min: 2, max: 6)),
                  _Button(
                    key: const Key('button_save_key'),
                    buttonText: 'Save',
                    height: height,
                    width: height + _screenSize.getHeight(min: 6, max: 10),
                    onTap: () async {
                      if (_saunaStore.isResettingProgram) return;
                      await _saunaStore.saveModifiedProgram();
                    },
                  ),
                  SizedBox(width: _screenSize.getHeight(min: 14, max: 24)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFirmwareUpdateInfoSection() {
    final theme = Theme.of(context).colorScheme;
    return Observer(builder: (context) {
      final width = _screenSize.getWidth(min: 230, max: 300);
      final height = _screenSize.getHeight(min: 46, max: 68);
      final isSettingsMenuSelected = _saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
      final showFirmwareUpdateInfo = _saunaStore.showFirmwareUpdateInfo && !isSettingsMenuSelected;

      return AnimatedContainer(
        height: showFirmwareUpdateInfo ? height + _screenSize.getHeight(min: 16, max: 26) : 0.0,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
          visible: showFirmwareUpdateInfo,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: _screenSize.getHeight(min: 16, max: 24)),
            child: Container(
              height: height,
              width: (width * 2) + _screenSize.getHeight(min: 8, max: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 6, max: 12)),
                border: Border.all(color: theme.programModifiedSectionBorderColor, width: 1),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.saunaUpdateInfo.toSvgPicture(
                    width: _screenSize.getHeight(min: 24, max: 32),
                    height: _screenSize.getHeight(min: 24, max: 32),
                    color: ThemeColors.dark20,
                  ),
                  SizedBox(width: _screenSize.getHeight(min: 6, max: 8)),
                  Text(
                    'The firmware will be updated after the session',
                    style: TextStyle(
                      fontSize: _screenSize.getFontSize(min: 12, max: 16),
                      fontWeight: FontWeight.w600,
                      color: theme.programModifiedTextColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSaunaStatusText() {
    final theme = Theme.of(context).colorScheme;
    final saunaDeviceState = _saunaStore.saunaState;
    final isSettingsMenuSelected = _saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
    final saunaSystem = _saunaStore.saunaSystem;
    return Text(
      key: Key(saunaDeviceState.name),
      isSettingsMenuSelected ? saunaSystem?.modelName ?? '' : saunaDeviceState.subtitleText,
      style: TextStyle(
        fontSize: _textSize,
        fontWeight: FontWeight.normal,
        color: theme.titleTextColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFirmwareVersionButton() {
    final saunaUpdateState = _saunaStore.saunaUpdateState;
    final pendingFirmwareVersion = _saunaStore.pendingFirmwareVersion;
    final theme = Theme.of(context).colorScheme;
    final showSaunaUpdateButton = saunaUpdateState == SaunaUpdateState.standby ||
        saunaUpdateState == SaunaUpdateState.failed ||
        saunaUpdateState == SaunaUpdateState.success;

    if (pendingFirmwareVersion != null && showSaunaUpdateButton) {
      return FeedbackSoundWrapper(
        onTap: () async {
          locator<SaunaStore>().setPopupType(type: PopupType.update);
          context.read<ScreenSaverStore>().cancelScreenSaverTimer();

          await Navigator.pushNamed(context, RouteGenerator.saunaUpdatePage);

          locator<SaunaStore>().setPopupType(type: PopupType.none);
          context.read<ScreenSaverStore>().setupScreenSaverTimer();
        },
        child: Container(
          height: _buttonSize.height,
          width: _buttonSize.width + _screenSize.getWidth(min: 60, max: 90),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
            color: ThemeColors.primaryBlueColor,
          ),
          alignment: Alignment.center,
          child: Text(
            'Update Firmware to Version ${_saunaStore.pendingFirmwareVersion}',
            style: TextStyle(
              fontSize: _textSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Text(
        _firmwareVersion,
        style: TextStyle(
          fontSize: _textSize,
          fontWeight: FontWeight.w500,
          color: theme.tickColor,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  String get _firmwareVersion {
    final saunaUpdateState = _saunaStore.saunaUpdateState;
    final pendingFirmwareVersion = _saunaStore.pendingFirmwareVersion;
    if (pendingFirmwareVersion != null && saunaUpdateState == SaunaUpdateState.standby) {
      return 'Update Firmware to Version ${_saunaStore.pendingFirmwareVersion}';
    } else {
      if (saunaUpdateState != null) {
        switch (saunaUpdateState) {
          case SaunaUpdateState.unknown:
          case SaunaUpdateState.standby:
          case SaunaUpdateState.success:
          case SaunaUpdateState.failed:
            return 'Firmware version ${_saunaStore.firmwareVersion}';
          case SaunaUpdateState.writing:
            return 'Updating Firmware to ${_saunaStore.pendingFirmwareVersion} Version.';
          case SaunaUpdateState.downloading:
          case SaunaUpdateState.refresh:
            return 'Downloading Firmware Version ${_saunaStore.pendingFirmwareVersion}';
        }
      }
      return 'Firmware version ${_saunaStore.firmwareVersion}';
    }
  }

  Widget _buildDeviceStateButton(SaunaStateButtonType saunaDeviceStateButtonType, SaunaState saunaState, Color color) {
    final theme = Theme.of(context).colorScheme;
    final hasFinishSession = saunaDeviceStateButtonType == SaunaStateButtonType.finishSession;
    final hasContinueTapped = saunaDeviceStateButtonType == SaunaStateButtonType.continueSession;
    final hasStopHeating = saunaDeviceStateButtonType == SaunaStateButtonType.stopHeating;
    final hasSaunaHeatingState = saunaState == SaunaState.heating;
    final hasSaunaReadyState = saunaState == SaunaState.ready;
    final hasStartSessionEarly =
        hasSaunaHeatingState && saunaDeviceStateButtonType == SaunaStateButtonType.startSession;
    final hasCancelSession = hasSaunaReadyState && saunaDeviceStateButtonType == SaunaStateButtonType.cancelSession;

    var title = saunaDeviceStateButtonType.title;

    if (hasStartSessionEarly) {
      title = 'Start Session Early';
    }

    return FeedbackSoundWrapper(
      key: Key(hasStartSessionEarly ? 'start_session_early_button' : saunaDeviceStateButtonType.name),
      onTap: () {
        SaunaState state = SaunaState.ready;
        if (hasFinishSession) {
          state = SaunaState.standby;
        } else if (hasContinueTapped || hasStartSessionEarly) {
          state = SaunaState.insession;
        } else if (hasCancelSession) {
          state = SaunaState.standby;
        } else {
          state = saunaState.changeState;
        }
        _saunaStore.setPopupType(type: PopupType.none);
        _saunaStore.setSaunaState(state);
        _screenSaverStore.cancelScreenSaverTimer();
        _screenSaverStore.setupScreenSaverTimer();
      },
      child: Container(
        height: _buttonSize.height,
        width: _buttonSize.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
          color: hasFinishSession || hasStopHeating || hasCancelSession ? theme.saunaButtonBackgroundColor : color,
          border: hasFinishSession || hasStopHeating || hasCancelSession ? Border.all(color: color, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: _textSize,
            fontWeight: FontWeight.w600,
            color: hasFinishSession || hasStopHeating || hasCancelSession ? color : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Size get _buttonSize {
    return Size(_screenSize.getWidth(min: 250, max: 300), _screenSize.getHeight(min: 50, max: 68));
  }

  double get _textSize {
    return _screenSize.getFontSize(min: 16, max: 20);
  }

  void _initAnimation() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = Tween(begin: 1.0, end: 100.0).animate(_animationController);
  }
}

class _Button extends StatelessWidget {
  final String buttonText;
  final double height;
  final double width;
  final Function() onTap;

  const _Button({
    Key? key,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: theme.programModifiedButtonTextColor,
          ),
        ),
      ),
    );
  }
}
