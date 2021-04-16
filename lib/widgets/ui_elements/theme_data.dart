import 'package:flutter/material.dart';

final ThemeData _themeData = new ThemeData(
  primaryTextTheme: TextTheme(
      headline6: TextStyle(color: Color(0xffff34b3)),
      bodyText2: TextStyle(color: Color(0xff201148))),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xff00ccfd),
    hoverColor: Color(0xff2011a2),
    splashColor: Color(0xffff34b3),
  ),
  accentIconTheme: IconThemeData(
    color: Color(0xff00ccfd),
  ),
  primaryIconTheme: IconThemeData(color: Color(0xff55e7ff)),
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  accentColor: Color(0xff55e7ff),
  buttonColor: Color(0xff55e7ff),
);
