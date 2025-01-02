// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:choco_tur_app_business/services/webapp_service.dart';
import 'package:choco_tur_app_business/utils/logger.dart';
import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:choco_tur_app_business/utils/validation.dart';
import 'package:choco_tur_app_business/widgets/home_page_background_painter.dart';
import 'package:choco_tur_app_business/widgets/loading_animation.dart';
import 'package:choco_tur_app_business/widgets/user_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _isRememberMeChecked = false;
  bool _loggingIn = false;

  void loginUser() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _loggingIn = true;
      });
      bool loginSuccess = await WebappService.loginBusiness(
        context,
        _emailController.text,
        _passwordController.text,
        _isRememberMeChecked,
      );
      setState(() {
        _loggingIn = false;
      });

      if (loginSuccess && mounted) {
        LoggerInstance.logger.i('Successfully logged in');
        Navigator.canPop(context) ? Navigator.pop(context) : Navigator.pushNamed(context, RouteNames.home);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomPaint(
        painter: HomePageBackgroundPainter(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Center(
                      child: Text("CHOCO TUR",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Styles.redShade,
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset("assets/login.png", fit: BoxFit.cover)),
                    ),
                    Center(
                      child: Text(AppLocalizations.of(context)!.loginWithCredentialsTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          )),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          UserTextInput(
                            controller: _emailController,
                            hintText: AppLocalizations.of(context)!.email,
                            validator: (email) => Validation.validateEmail(context, email),
                          ),
                          UserTextInput(
                            controller: _passwordController,
                            hintText: AppLocalizations.of(context)!.password,
                            obscured: true,
                            validator: (password) => Validation.validatePassword(context, password),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CheckboxListTile(
                            title: Text(AppLocalizations.of(context)!.rememberMe,
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                            controlAffinity: ListTileControlAffinity.leading,
                            checkColor: Styles.redShade,
                            activeColor: Styles.onRedShade,
                            visualDensity: const VisualDensity(horizontal: -4),
                            value: _isRememberMeChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isRememberMeChecked = value!;
                              });
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RouteNames.passwordRecoveryProcess);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                              style: TextStyle(fontSize: 15, color: Styles.redShade),
                            ))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: loginUser,
                                style: ElevatedButton.styleFrom(backgroundColor: Styles.redShade),
                                child: Text(
                                  AppLocalizations.of(context)!.signInButtonLabel,
                                  style: const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.w300, color: Styles.onRedShade),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(AppLocalizations.of(context)!.or,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                )),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dontHaveAnAccountQ,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(left: 5),
                            ),
                            onPressed: () => {Navigator.pushNamed(context, RouteNames.registrationProcess)},
                            child: Text(
                              AppLocalizations.of(context)!.createAnAccount,
                              style: TextStyle(fontSize: 15, color: Styles.redShade),
                            ))
                      ],
                    ),
                  ],
                ),
                if (_loggingIn)
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
