import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:ynotes/UI/components/modalBottomSheets/utils.dart';
import 'package:ynotes/UI/components/space/spaceOverlay.dart';
import 'package:ynotes/UI/screens/spacePageWidgets/agendaGrid.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import '../../../background.dart';
import '../../../usefulMethods.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/apiManager.dart';
import 'dart:async';
import 'package:ynotes/UI/components/expandable_bottom_sheet-master/src/raw_expandable_bottom_sheet.dart';
import 'dart:io';

class SpaceAgenda extends StatefulWidget {
  @override
  _SpaceAgendaState createState() => _SpaceAgendaState();
}

enum explorerSortValue { date, reversed_date, name }
Future agendaFuture;

class _SpaceAgendaState extends State<SpaceAgenda> {
  DateTime date = DateTime.now();
  @override
  List<FileInfo> listFiles;
  // ignore: must_call_super
  void initState() {
    // TODO: implement initState
    getLessons(date);
  }

  //Force get date
  getLessons(DateTime date) async {
    await refreshAgendaFuture(force: false);
  }

  Future<void> refreshAgendaFuture({bool force = true}) async {
    if (mounted) {
      setState(() {
        agendaFuture = localApi.getNextLessons(date, forceReload: force);
      });
    }

    var realLF = await agendaFuture;
  }

  _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      child: Container(
        width: 60,
        height: 60,
        child: Icon(
          Icons.add,
          size: 40,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
              colors: [const Color(0xFFFFFFEE), const Color(0xFFB4ACDC)],
            )),
      ),
      onPressed: () async {
        //agendaEventBottomSheet(context);
      },
    );
  }

  _buildActualLesson(BuildContext context, Lesson lesson) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder(
        future: getColor(lesson.codeMatiere),
        initialData: 0,
        builder: (context, snapshot) {
          Color color = Color(snapshot.data);
          return Container(
            width: screenSize.size.width / 5 * 4.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: screenSize.size.width / 5 * 4.5,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.85),
                  ),
                  height: screenSize.size.height / 10 * 2.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenSize.size.width / 5 * 4.4,
                        height: screenSize.size.height / 10 * 1.57,
                        padding: EdgeInsets.all(screenSize.size.height / 10 * 0.05),
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                lesson.matiere,
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w800),
                                maxLines: 4,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                lesson.teachers[0],
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                              ),
                              Text(
                                lesson.room,
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
                        width: screenSize.size.width / 5 * 2.5,
                        height: screenSize.size.height / 10 * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                          color: Color(0xffC4C4C4),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Text(
                                DateFormat.Hm().format(lesson.start),
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                              Icon(MdiIcons.arrowRight, color: isDarkModeEnabled ? Colors.white : Colors.black),
                              Text(
                                DateFormat.Hm().format(lesson.end),
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _buildAgendaButtons(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width / 5 * 4.2,
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.005, horizontal: screenSize.size.width / 5 * 0.05),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
              child: Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                  onTap: () {
                    setState(() {
                      date = date.subtract(Duration(days: 1));
                    });
                    getLessons(date);
                  },
                  child: Container(
                      height: screenSize.size.height / 10 * 0.45,
                      width: screenSize.size.width / 5 * 1,
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              MdiIcons.arrowLeft,
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
              child: Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                  onTap: () async {
                    DateTime someDate = await showDatePicker(
                      locale: Locale('fr', 'FR'),
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                      helpText: "",
                      builder: (BuildContext context, Widget child) {
                        return FittedBox(
                          child: Material(
                            color: Colors.transparent,
                            child: Theme(
                              data: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[SizedBox(child: child)],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    if (someDate != null) {
                      setState(() {
                        date = someDate;
                      });
                      getLessons(date);
                    }
                  },
                  child: Container(
                      height: screenSize.size.height / 10 * 0.45,
                      width: screenSize.size.width / 5 * 2,
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              DateFormat("EEEE dd MMMM", "fr_FR").format(date),
                              style: TextStyle(
                                fontFamily: "Asap",
                                color: isDarkModeEnabled ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
              child: Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                  onTap: () {
                    setState(() {
                      date = date.add(Duration(days: 1));
                    });
                    getLessons(date);
                  },
                  child: Container(
                      height: screenSize.size.height / 10 * 0.45,
                      width: screenSize.size.width / 5 * 1,
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              MdiIcons.arrowRight,
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 6.5,
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
          color: Theme.of(context).primaryColor,
        ),
        width: screenSize.size.width / 5 * 4.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
          child: Container(
            width: screenSize.size.width,
            height: screenSize.size.height,
            child: Container(
              width: screenSize.size.width,
              height: screenSize.size.height,
              padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    _buildAgendaButtons(context),
                    Container(
                      height: screenSize.size.height / 10 * 5.8,
                      padding: EdgeInsets.all(screenSize.size.height / 10 * 0.1),
                      child: Stack(
                        children: [
                          FutureBuilder(
                              future: agendaFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null && snapshot.data.length != 0) {
                                  return Container();
                                }
                                if (snapshot.data != null && snapshot.data.length == 0) {
                                  return Center(
                                    child: FittedBox(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.5),
                                            height: screenSize.size.height / 10 * 1.9,
                                            child: Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/relax.png')),
                                          ),
                                          Text(
                                            "Journée détente ?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              //Reload list
                                              getLessons(date);
                                            },
                                            child: snapshot.connectionState != ConnectionState.waiting
                                                ? Text("Recharger", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
                                                : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return SpinKitFadingFour(
                                    color: Theme.of(context).primaryColorDark,
                                    size: screenSize.size.width / 5 * 1,
                                  );
                                }
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}




 
