import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPage extends StatelessWidget {
  // This is the list of the available school services
  // This is only temporary and should be stored in the [API] class
  static final List<SchoolServiceBox> _services = [
    SchoolServiceBox(
        image: const AssetImage('assets/images/icons/ecoledirecte/EcoleDirecteIcon.png'),
        imageColor: theme.colors.foregroundColor,
        name: 'Ecole Directe',
        route: '/login/ecoledirecte',
        parser: 0),
    const SchoolServiceBox(
        image: AssetImage('assets/images/icons/pronote/PronoteIcon.png'),
        name: 'Pronote',
        route: '/login/pronote',
        parser: 1),
    // LA VIE SCOLAIRE, beta = true
    //const SchoolServiceBox(name: "Démonstrations", route: "/login/demos")
  ];

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
      backButton: false,
      subtitle: LoginContent.login.subtitle,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: double.infinity,
            decoration: BoxDecoration(color: theme.colors.danger.backgroundColor, borderRadius: YBorderRadius.xl),
            padding: EdgeInsets.symmetric(vertical: YScale.s1p5, horizontal: YScale.s6),
            child: Column(
              children: [
                Text(
                  LoginContent.login.endOfSupport,
                  style: theme.texts.body1.copyWith(color: theme.colors.danger.foregroundColor),
                  textAlign: TextAlign.justify,
                ),
                YButton(
                  text: LoginContent.login.learnMore,
                  variant: YButtonVariant.text,
                  onPressed: () async {
                    launch("https://ynotes.fr");
                  },
                ),
              ],
            )),
        YVerticalSpacer(YScale.s2),
        ...spacedChildren(_services),
        Padding(
          padding: YPadding.pt(YScale.s1),
          child: YButton(
            text: LoginContent.login.missingService,
            variant: YButtonVariant.text,
            onPressed: () async {
              await YDialogs.showInfo(
                  context,
                  YInfoDialog(
                    title: LoginContent.login.missingService,
                    body: Text(LoginContent.login.dialogBody, style: theme.texts.body1),
                    confirmLabel: "OK",
                  ));
            },
          ),
        ),
      ]),
    );
  }
}
