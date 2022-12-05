// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

//? text styles
//@ h1 text styles
TextStyle h1TextStyle = TextStyle(
  fontSize: h1TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
TextStyle h1LiteTextStyle = TextStyle(
  fontSize: h1TextSize,
  fontFamily: 'Cairo',
);
TextStyle h1LightTextStyle = TextStyle(
  fontSize: h1TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);

//@ h2 text styles
TextStyle h2TextStyle = TextStyle(
  fontSize: h2TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
TextStyle h2liteTextStyle = TextStyle(
  fontSize: h2TextSize,
  fontFamily: 'Cairo',
);
TextStyle h2LightTextStyle = TextStyle(
  fontSize: h2TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);

//@ h3 text styles
TextStyle h3TextStyle = TextStyle(
  fontSize: h3TextSize,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
TextStyle h3LiteTextStyle = TextStyle(
  color: kInactiveColor,
  fontSize: h3TextSize,
  fontFamily: 'Cairo',
);
TextStyle h3InactiveTextStyle = TextStyle(
  fontSize: h3TextSize,
  fontFamily: 'Cairo',
  color: kInActiveTextColor,
);
TextStyle h3LightTextStyle = TextStyle(
  fontSize: h3TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);

//@ h4 text styles
TextStyle h4TextStyle = TextStyle(
  fontSize: h4TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
TextStyle h4TextStyleInactive = TextStyle(
  fontSize: h4TextSize,
  fontWeight: FontWeight.w400,
  color: kInActiveTextColor,
  fontFamily: 'Cairo',
);
TextStyle h4LiteTextStyle = TextStyle(
  fontSize: h4TextSize,
  fontFamily: 'Cairo',
);
TextStyle h4LightTextStyle = TextStyle(
  fontSize: h4TextSize,
  fontFamily: 'Cairo',
  color: kActiveTextColor,
);

//@ h5 text styles
TextStyle h5TextStyle = TextStyle(
  fontSize: h5TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
TextStyle h5InactiveTextStyle = TextStyle(
  fontSize: h5TextSize,
  color: kInActiveTextColor,
  fontFamily: 'Cairo',
);
TextStyle h5LightTextStyle = TextStyle(
  fontSize: h5TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);
TextStyle h5LiteTextStyle = TextStyle(
  fontSize: h5TextSize,
  fontFamily: 'Cairo',
);

//? box shadows
BoxShadow defaultBoxShadow = BoxShadow(
  spreadRadius: 5,
  blurRadius: 15,
  color: Colors.grey.withOpacity(0.1),
);
BoxShadow liteBoxShadow = BoxShadow(
  offset: Offset(0, 0),
  color: Colors.grey.withOpacity(.2),
  blurStyle: BlurStyle.outer,
  blurRadius: 6,
);
