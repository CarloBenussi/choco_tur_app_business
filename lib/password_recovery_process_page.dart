import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:choco_tur_app_business/services/webapp_service.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:choco_tur_app_business/utils/validation.dart';
import 'package:choco_tur_app_business/widgets/home_page_background_painter.dart';
import 'package:choco_tur_app_business/widgets/loading_animation.dart';
import 'package:choco_tur_app_business/widgets/login_button.dart';
import 'package:choco_tur_app_business/widgets/user_text_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryProcessPage extends StatefulWidget {
  const PasswordRecoveryProcessPage({super.key});

  @override
  State<PasswordRecoveryProcessPage> createState() => _PasswordRecoveryProcessPageState();
}

class _PasswordRecoveryProcessPageState extends State<PasswordRecoveryProcessPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  int _currentPageIndex = 0;
  bool _backPressed = false;
  bool _processing = false;

  String? _collectedEmail;
  String? _collectedPasswordRecoveryNumber;
  String? _collectedNewPassword;
  String? _collectedNewMatchingPassword;

  String? _validateMatchingPassword(BuildContext context, String? matchingPassword) {
    if (matchingPassword != _collectedNewPassword) {
      return AppLocalizations.of(context)!.invalidMatchingPassword;
    }

    return null;
  }

  void _checkCodeCompletion(String text, BuildContext context) async {
    if (text.length == 6) {
      setState(() {
        _processing = true;
      });
      bool confirmSuccess = await WebappService.resetPasswordTest(context, _collectedEmail!, text);
      setState(() {
        _processing = true;
      });
      if (confirmSuccess && mounted) {
        _onNextPressed(context);
      }
    }
  }

  void _onNextPressed(BuildContext context) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    // Collect.
    if (_currentPageIndex == 0) {
      _collectedEmail = _controller.text;
    } else if (_currentPageIndex == 1) {
      _collectedPasswordRecoveryNumber = _controller.text;
    } else if (_currentPageIndex == 2) {
      _collectedNewPassword = _controller.text;
    } else if (_currentPageIndex == 3) {
      _collectedNewMatchingPassword = _controller.text;
    }

    // Send
    bool success = true;
    setState(() {
      _processing = true;
    });
    if (_currentPageIndex == 0) {
      success = await WebappService.resetPassword(context, _collectedEmail!);
    } else if (_currentPageIndex == 3) {
      success = await WebappService.changePassword(context, _collectedEmail!, _collectedPasswordRecoveryNumber!,
          _collectedNewPassword!, _collectedNewMatchingPassword!);
    }

    setState(() {
      _processing = false;
    });

    if (!success) {
      return;
    }

    setState(() {
      _currentPageIndex++;
      _controller.clear();
    });
  }

  void _onBackPressed(BuildContext context) {
    _currentPageIndex--;
    _backPressed = true;
    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 800),
        reverse: _backPressed,
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Styles.onRedShade,
            child: child,
          );
        },
        child: Container(
          key: ValueKey<int>(_currentPageIndex),
          child: CustomPaint(
            painter: HomePageBackgroundPainter(),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Builder(builder: (context) {
                          if (_currentPageIndex == 0) {
                            return UserTextInput(
                              controller: _controller,
                              hintText: AppLocalizations.of(context)!.email,
                              validator: (input) => Validation.validateEmail(context, input),
                            );
                          } else if (_currentPageIndex == 1) {
                            return TextField(
                              controller: _controller,
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context)!.confirmPasswordChangeCode),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              onChanged: (text) => _checkCodeCompletion(text, context),
                            );
                          } else if (_currentPageIndex == 2) {
                            return UserTextInput(
                              controller: _controller,
                              hintText: AppLocalizations.of(context)!.newPassword,
                              validator: (input) => Validation.validatePassword(context, input),
                              obscured: true,
                            );
                          } else if (_currentPageIndex == 3) {
                            return UserTextInput(
                              controller: _controller,
                              hintText: AppLocalizations.of(context)!.matchingPassword,
                              validator: (input) => _validateMatchingPassword(context, input),
                              obscured: true,
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.passwordResetSuccess,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.redShade,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: LoginButton(clearNavigator: true),
                                )
                              ],
                            );
                          }
                        }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: _currentPageIndex > 0 ? () => _onBackPressed(context) : null,
                          child: Text(
                            AppLocalizations.of(context)!.backButton,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: (_currentPageIndex > 0) ? Styles.redShade : null,
                            ),
                          ),
                        ),
                        if (_currentPageIndex != 1)
                          TextButton(
                            onPressed: () => _onNextPressed(context),
                            child: Text(
                              (_currentPageIndex < 4)
                                  ? AppLocalizations.of(context)!.nextButton
                                  : AppLocalizations.of(context)!.registerButton,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Styles.redShade,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (_processing)
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: const Center(
                      child: LoadingAnimation(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
