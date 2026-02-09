import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class
  static const red = Color(0xFFD1323A);
  static const green = Color(0xFF02C39A);
  static const yellow = Color(0xFFFDD85D);
  static const orange = Color(0xFFF5793A);
  static const blue = Color(0xFF85C0F9);
  static const grey = Color(0xFF48495F);
  static const primary = Color(0xFF6F7276);
  static const secondary = Color(0xFFCED5DB);
  static const tertiary = Color(0xFFE7EFF6);
  static const darkBackground = Color(0xFF1D1F25);

  static const backgroundColor = Color(0xFF14133b);
  static const backgroundColorLight = Color(0xFF1f1b4e);
  static const lightLessColor = Color(0xFF434162);
  static const darkLessColor = Color(0xFF212531);

  static const primary100 = Color(0xff315ca1);
  static const primary80 = Color(0xFF5D72FC);
  static const primary60 = Color(0xFF6D81FD);
  static const primary40 = Color(0xFF7E8FFD);
  static const primary20 = Color(0xFF8F9EFD);

  static const secondary100 = Color(0xFF2AEAFE);
  static const secondary80 = Color(0xFF3BECFE);
  static const secondary60 = Color(0xFF4CEDFE);
  static const secondary40 = Color(0xFF5DEFFE);
  static const secondary20 = Color(0xFF7FF2FE);

  static const gray100 = Color(0xFF8A8C91);
  static const gray80 = Color(0xFF979797);
  static const gray60 = Color(0xFFD9D9D9);
  static const gray40 = Color(0xFFF1F2F6);
  static const gray20 = Color(0xFFEEF2F5);

  static const dark100 = Color(0xFF000000);
  static const dark80 = Color(0xFF14133B);
  static const dark60 = Color(0xFF252D30);
  static const dark40 = Color(0xFF8293C7);
  static const dark20 = Color(0xFF8E9DCC);

  static const success100 = Color(0xFF53F36D);
  static const success80 = Color(0xFF23F045);
  static const success60 = Color(0xFF0FD12E);
  static const success40 = Color(0xFF0BA224);
  static const success20 = Color(0xFF087219);

  static const warning100 = Color(0xFFF3C053);
  static const warning80 = Color(0xFFF6B049);
  static const warning60 = Color(0xFFF9A03F);
  static const warning40 = Color(0xFFF27F34);
  static const warning20 = Color(0xFFEB5E28);

  static const error100 = Color(0xFFE5383B);
  static const error80 = Color(0xFFBA181B);
  static const error60 = Color(0xFFA4161A);
  static const error40 = Color(0xFF881013);
  static const error20 = Color(0xFF660708);

  static const gradianPimary = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF2AEAFE),
      Color(0xFF4C64FC),
    ],
  );
  static const gradianPimaryLeftRight = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF2AEAFE),
      Color(0xFF4C64FC),
    ],
  );

  static const gdBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF60CDF3),
      Color(0xFF4598F8),
    ],
  );

  static const gdPink = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFFFC91A3),
      Color(0xFFF76C96),
    ],
  );

  static const gdCyan = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF31EEFA),
      Color(0xFF1BD2CD),
    ],
  );

  static const gdOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFFFBD455),
      Color(0xFFF08235),
    ],
  );

  static const gdPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFFF36DC2),
      Color(0xFF9D41C6),
    ],
  );

  static const gdBluePurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF9479FE),
      Color(0xFF9D41C6),
    ],
  );

  static const gdFlamingo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFFFD8853),
      Color(0xFFFD5787),
    ],
  );

  static const gdJade = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF03D1C0),
      Color(0xFF009A8C),
    ],
  );
}
