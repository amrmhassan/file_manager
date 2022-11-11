// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

//? text styles
//@ h1 text styles
const TextStyle h1TextStyle = TextStyle(
  fontSize: h1TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
const TextStyle h1LiteTextStyle = TextStyle(
  fontSize: h1TextSize,
  fontFamily: 'Cairo',
);
const TextStyle h1LightTextStyle = TextStyle(
  fontSize: h1TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);

//@ h2 text styles
const TextStyle h2TextStyle = TextStyle(
  fontSize: h2TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
const TextStyle h2liteTextStyle = TextStyle(
  fontSize: h2TextSize,
  fontFamily: 'Cairo',
);
const TextStyle h2LightTextStyle = TextStyle(
  fontSize: h2TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);

//@ h3 text styles
const TextStyle h3TextStyle = TextStyle(
  fontSize: h3TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
const TextStyle h3LiteTextStyle = TextStyle(
  color: kInactiveColor,
  fontSize: h3TextSize,
  fontFamily: 'Cairo',
);
const TextStyle h3InactiveTextStyle = TextStyle(
  fontSize: h3TextSize,
  fontFamily: 'Cairo',
  color: kInActiveTextColor,
);
const TextStyle h3LightTextStyle = TextStyle(
  fontSize: h3TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);

//@ h4 text styles
const TextStyle h4TextStyle = TextStyle(
  fontSize: h4TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
const TextStyle h4TextStyleInactive = TextStyle(
  fontSize: h4TextSize,
  fontWeight: FontWeight.w400,
  color: kInActiveTextColor,
  fontFamily: 'Cairo',
);
const TextStyle h4LiteTextStyle = TextStyle(
  fontSize: h4TextSize,
  fontFamily: 'Cairo',
);
const TextStyle h4LightTextStyle = TextStyle(
  fontSize: h4TextSize,
  fontFamily: 'Cairo',
  color: Colors.white,
);

//@ h5 text styles
const TextStyle h5TextStyle = TextStyle(
  fontSize: h5TextSize,
  fontWeight: FontWeight.bold,
  fontFamily: 'Cairo',
);
const TextStyle h5InactiveTextStyle = TextStyle(
  fontSize: h5TextSize,
  color: kInActiveTextColor,
  fontFamily: 'Cairo',
);
const TextStyle h5LightTextStyle = TextStyle(
  fontSize: h5TextSize,
  color: Colors.white,
  fontFamily: 'Cairo',
);
const TextStyle h5LiteTextStyle = TextStyle(
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
