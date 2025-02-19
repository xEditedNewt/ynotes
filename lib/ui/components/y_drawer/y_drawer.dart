import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/y_drawer/widgets/account_header.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class YDrawer extends StatefulWidget {
  const YDrawer({Key? key}) : super(key: key);

  @override
  _YDrawerState createState() => _YDrawerState();
}

class _SpecialRoute {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _SpecialRoute({required this.title, required this.icon, required this.onTap});
}

class _YDrawerState extends State<YDrawer> {
  @override
  Widget build(BuildContext context) {
    bool availableRoute(CustomRoute route) {
      if (!route.show) return false;
      return (route.tab != null && appSys.currentSchoolAccount!.availableTabs.contains(route.tab) ||
          (route.relatedApi == -1 && !kReleaseMode));
    }

    final List<_SpecialRoute> specialRoutes = [
      _SpecialRoute(title: "Paramètres", icon: Icons.settings, onTap: () => Navigator.pushNamed(context, "/settings")),
    ];

    final List<_SpecialRoute> specialIcons = [
      _SpecialRoute(
          title: "Discord",
          icon: FontAwesomeIcons.discord,
          onTap: () async => await launch("https://discord.gg/pRCBs22dNX")),
      _SpecialRoute(
          title: "Github",
          icon: FontAwesomeIcons.github,
          onTap: () async => await launch("https://github.com/EduWireApps/ynotes")),
      _SpecialRoute(
          title: "Centre d'aide", icon: Icons.help, onTap: () async => await launch("https://support.ynotes.fr/")),
    ];

    final Color backgroundColor = theme.colors.backgroundColor;

    return Drawer(
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: YShadowScrollContainer(color: backgroundColor, children: [
            const AccountHeader(),
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: routes.length,
                itemBuilder: (context, i) {
                  final route = routes[i];

                  if (!availableRoute(route)) {
                    return Container();
                  }

                  final bool isCurrent = ModalRoute.of(context)!.settings.name == route.path;
                  final Color textColor = isCurrent ? theme.colors.foregroundColor : theme.colors.foregroundLightColor;

                  return Container(
                    color: isCurrent ? theme.colors.backgroundLightColor : null,
                    child: ListTile(
                      leading: Icon(
                        route.icon,
                        color: textColor,
                      ),
                      title: Text(route.title ?? "", style: TextStyle(color: textColor, fontSize: 18)),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name == route.path) {
                          return;
                        }
                        Navigator.pop(context);

                        Navigator.pushNamed(context, route.path);
                      },
                    ),
                  );
                }),
            YVerticalSpacer(YScale.s4),
            const YDivider(),
            YVerticalSpacer(YScale.s4),
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: specialRoutes.length,
                itemBuilder: (context, i) {
                  final _SpecialRoute route = specialRoutes[i];

                  return ListTile(
                    leading: Icon(
                      route.icon,
                      color: theme.colors.foregroundLightColor,
                    ),
                    title: Text(route.title, style: TextStyle(color: theme.colors.foregroundLightColor, fontSize: 18)),
                    onTap: route.onTap,
                  );
                }),
            YVerticalSpacer(YScale.s4),
            const YDivider(),
            YVerticalSpacer(YScale.s4),
            Row(
              children: [
                for (final e in specialIcons)
                  Expanded(
                      child: IconButton(
                    icon: Icon(e.icon),
                    color: theme.colors.foregroundLightColor,
                    onPressed: e.onTap,
                  ))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
