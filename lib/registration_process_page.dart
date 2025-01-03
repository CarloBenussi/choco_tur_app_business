import 'dart:async';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:choco_tur_app_business/models/choco_tur_business.dart';
import 'package:choco_tur_app_business/services/webapp_service.dart';
import 'package:choco_tur_app_business/utils/logger.dart';
import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:choco_tur_app_business/utils/validation.dart';
import 'package:choco_tur_app_business/widgets/home_page_background_painter.dart';
import 'package:choco_tur_app_business/widgets/loading_animation.dart';
import 'package:choco_tur_app_business/widgets/user_text_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RegistrationProcessPage extends StatefulWidget {
  const RegistrationProcessPage({super.key});

  @override
  State<RegistrationProcessPage> createState() => _RegistrationProcessPageState();
}

class _RegistrationProcessPageState extends State<RegistrationProcessPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  int _currentPageIndex = 0;
  bool _backPressed = false;
  bool _registering = false;

  late String _collectedInvitationToken;
  late String _collectedEmail;
  late String _collectedPassword;
  late String _collectedMatchingPassword;
  String? _collectedEmailVerificationNumber;

  bool _resendCodeAvailable = false;

  String? _validateMatchingPassword(BuildContext context, String? matchingPassword) {
    if (matchingPassword != _collectedPassword) {
      return AppLocalizations.of(context)!.invalidMatchingPassword;
    }

    return null;
  }

  Future<bool> _validateInvitationToken(BuildContext context) async {
    setState(() {
      _registering = true;
    });
    bool invitationValidationSuccess =
        await WebappService.validateInvitation(context, _collectedEmail, _collectedInvitationToken);

    setState(() {
      _registering = false;
    });

    return invitationValidationSuccess;
  }

  Future<String?> _register(BuildContext context) async {
    setState(() {
      _registering = true;
    });
    String? deviceRegistrationToken = Provider.of<ChocoTurBusiness>(context, listen: false).deviceRegistrationToken;
    String? responseBody = await WebappService.registerBusiness(
      context,
      _collectedEmail,
      _collectedPassword,
      _collectedMatchingPassword,
      _collectedInvitationToken,
      deviceRegistrationToken!,
    );
    setState(() {
      _registering = false;
    });

    return responseBody;
  }

  void _checkCodeCompletion(String text, BuildContext context) async {
    LoggerInstance.logger.d(text);
    if (text.length == 6) {
      bool confirmSuccess = await WebappService.confirmEmail(context, _collectedEmail, text);
      if (confirmSuccess && mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }
    }
  }

  void _resendCode() async {
    setState(() {
      _resendCodeAvailable = false;
    });
    String? responseBody =
        await WebappService.resendEmailVerificationCode(context, _collectedEmail, _collectedEmailVerificationNumber!);
    if (responseBody == null) {
      setState(() {
        _resendCodeAvailable = true;
      });
      return;
    }

    _collectedEmailVerificationNumber = responseBody;
    Timer(const Duration(seconds: 60), () {
      setState(() {
        _resendCodeAvailable = true;
      });
    });
  }

  void _onNextPressed(BuildContext context) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if (_currentPageIndex == 0) {
      _collectedInvitationToken = _controller.text;
    } else if (_currentPageIndex == 1) {
      _collectedEmail = _controller.text;
      bool success = await _validateInvitationToken(context);
      if (!success) {
        return;
      }
    } else if (_currentPageIndex == 2) {
      _collectedPassword = _controller.text;
    } else if (_currentPageIndex == 3) {
      _collectedMatchingPassword = _controller.text;
      String? responseBody = await _register(context);
      if (responseBody == null) {
        return;
      } else {
        _collectedEmailVerificationNumber = responseBody;
        _resendCodeAvailable = true;
      }
    }

    if (_currentPageIndex < 4) {
      _backPressed = false;
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _formKey = GlobalKey<FormState>();
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
                              hintText: AppLocalizations.of(context)!.invitationToken,
                              validator: (input) => Validation.validateInvitationToken(context, input),
                            );
                          } else if (_currentPageIndex == 1) {
                            return UserTextInput(
                              controller: _controller,
                              hintText: AppLocalizations.of(context)!.email,
                              validator: (input) => Validation.validateEmail(context, input),
                            );
                          } else if (_currentPageIndex == 2) {
                            return UserTextInput(
                              controller: _controller,
                              hintText: AppLocalizations.of(context)!.password,
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
                            Timer(const Duration(seconds: 60), () {
                              setState(() {
                                _resendCodeAvailable = true;
                              });
                            });
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: AppLocalizations.of(context)!.confirmEmailCode),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) => _checkCodeCompletion(text, context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: TextButton(
                                    onPressed: (_resendCodeAvailable) ? _resendCode : null,
                                    child: Text(
                                      AppLocalizations.of(context)!.resendEmailCode +
                                          ((_resendCodeAvailable)
                                              ? ""
                                              : (" (${AppLocalizations.of(context)!.availableIn}60s)")),
                                      style: TextStyle(color: (_resendCodeAvailable) ? Styles.redShade : Colors.grey),
                                    ),
                                  ),
                                ),
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
                        if (_currentPageIndex < 5)
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
                if (_registering)
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
