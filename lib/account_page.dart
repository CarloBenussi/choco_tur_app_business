import 'package:choco_tur_app_business/models/choco_tur_business.dart';
import 'package:choco_tur_app_business/widgets/app_bar.dart';
import 'package:choco_tur_app_business/widgets/login_button.dart';
import 'package:choco_tur_app_business/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const ChocoTurAppBar(),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          if (!Provider.of<ChocoTurBusiness>(context).loggedIn) {
            return const Center(child: LoginButton());
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        Provider.of<ChocoTurBusiness>(context).loginEmail!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        }),
        bottomNavigationBar: const ChocoTurNavigationBar(),
      ),
    );
  }
}
