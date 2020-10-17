import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ynotes/UI/components/modalBottomSheets/utils.dart';
import 'package:ynotes/UI/utils/themeUtils.dart';
import '../../../apiManager.dart';
import '../../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';

import '../gradesChart.dart';

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void disciplineModalBottomSheet(context, Discipline discipline, Function callback, var widget, Function colorPicker) {
  Color colorGroup;
  if (widget.disciplinevar == null) {
    colorGroup = Colors.blueAccent;
  } else {
    if (widget.disciplinevar.color != null) {
      colorGroup = Color(widget.disciplinevar.color);
    }
  }
  MediaQueryData screenSize = MediaQuery.of(context);
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: screenSize.size.height / 10 * 3.0,
            padding: EdgeInsets.all(0),
            child: new Column(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenSize.size.width * 0.8),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: colorGroup),
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text(
                              discipline.nomDiscipline,
                              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                            height: (screenSize.size.height / 3) / 6,
                            width: (screenSize.size.height / 3) / 6,
                            padding: EdgeInsets.all(5),
                            child: Material(
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.grey.withOpacity(0.5),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(80),
                                  radius: 25,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    Color color = colorPicker(context, Color(discipline.color));

                                    if (color != null) {
                                      String test = color.toString();
                                      String finalColor = "#" + test.toString().substring(10, test.length - 1);
                                      final prefs = await SharedPreferences.getInstance();
                                      prefs.setString(discipline.codeMatiere, finalColor);
                                      discipline.setcolor = color;
                                    }
                                  },
                                  splashColor: Colors.grey,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    child: Icon(
                                      Icons.color_lens,
                                      color: Colors.black26,
                                    ),
                                  ),
                                )))
                      ],
                    ),
                  ),
                ),
                Container(
                  height: screenSize.size.height / 10 * 2,
                  margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildKeyValuesInfo(context, "Votre moyenne", [discipline.moyenne]),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        buildKeyValuesInfo(context, "Moyenne de la classe", [discipline.moyenneClasse]),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        buildKeyValuesInfo(context, "Moyenne la plus élevée", [discipline.moyenneMax]),
                        if (discipline.moyenneMin != null)
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                        if (discipline.moyenneMin != null) buildKeyValuesInfo(context, "Moyenne la plus basse", [discipline.moyenneMin]),
                      ],
                    ),
                  ),
                )
              ],
            ));
      });
}
