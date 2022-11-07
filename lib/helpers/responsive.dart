// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

//* this variable is the devices types that the app supports
//* you can add more devices types for more specifications

// [The idea of this file is to return the suitable widget of the current screen size
// the user can provide different widgets for different devices types
// and the method will return the suitable widget of the device size
// i made the pc and mobile widgets required otherwise the user won't need to use this class at all
// if the suitable widgets isn't provided i will return the pc or mobile depending on which size is the nearest to it
//? mobile represent the small screens and pc represent the large screen
//! i need to make sure that the widget that is gonna be returned is the nearest provided not only the pc or mobile ]
//! -- and for making that i have to divide the sizes to small and large

//! -- the principle is to provide the smaller screen for every absent screen (large or small)

//! -- for the small screens if it is the smallest of the small screen i need to choose the nearest larger  screen for it
//! -- else i will provide the next small screen to presented for it if it isn't provided by the class consumer

//! -- for the large screens if it is the smallest of the large screen i need to provide the next large screen
//! -- else i will provide the smaller screen for it

enum Device {
  smallMobile,
  mobile,
  tablet,
  laptop,
  pc,
  tv,
}

//* these are the breakpoints of the screen sizes
const Map<Device, List<double>> breakpoints = {
  Device.smallMobile: [0, 319],
  Device.mobile: [320, 654],
  Device.tablet: [655, 768],
  Device.laptop: [769, 1024],
  Device.pc: [1025, 1200],
  Device.tv: [1201, double.infinity],
};
const List<Device> smallScreen = [Device.smallMobile, Device.mobile];
const List<Device> mediumScreen = [Device.tablet, Device.laptop];
const List<Device> largeScreen = [Device.pc, Device.tv];

//* the class that has all needed methods of returning the suitable widget depending on the device size
class Responsive extends StatelessWidget {
  //* different widgets for different devices sizes
  //* pc and mobile are required
  //? the class consumer can depend on the deviceType method for returning the current device size or
  //? depend on our method  suitableDeviceWidget for returning the Widget automatically but
  //? he must provide the Widget for mobile and pc
  final Widget? smallMobile;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? laptop;
  final Widget? pc;
  final Widget? tv;

  const Responsive({
    Key? key,
    this.smallMobile,
    this.mobile,
    this.tablet,
    this.laptop,
    this.pc,
    this.tv,
  }) : super(key: key);

//? to get the full device width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

//? to get the full device height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

//? to get the height of the screen without the toolbar
  static double getCleanHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight;
  }

  //? get width percentage
  static double getWidthPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  //? get Height percentage
  static double getHeightPercentage(BuildContext context, int percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

//* that method will return the device type
//* depending on the above sizes constant
  Device deviceType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= breakpoints[Device.smallMobile]![0] &&
        width <= breakpoints[Device.smallMobile]![1]) {
      return Device.smallMobile;
    } else if (width >= breakpoints[Device.mobile]![0] &&
        width <= breakpoints[Device.mobile]![1]) {
      return Device.mobile;
    } else if (width >= breakpoints[Device.tablet]![0] &&
        width <= breakpoints[Device.tablet]![1]) {
      return Device.tablet;
    } else if (width >= breakpoints[Device.laptop]![0] &&
        width <= breakpoints[Device.laptop]![1]) {
      return Device.laptop;
    } else if (width >= breakpoints[Device.pc]![0] &&
        width <= breakpoints[Device.pc]![1]) {
      return Device.pc;
    } else {
      return Device.tv;
    }
  }

//* this method will return the widget for the current size
  Widget? renderDeviceWidget(BuildContext context) {
    if (deviceType(context) == Device.smallMobile) {
      return smallMobile;
    } else if (deviceType(context) == Device.mobile) {
      return mobile;
    } else if (deviceType(context) == Device.tablet) {
      return tablet;
    } else if (deviceType(context) == Device.laptop) {
      return laptop;
    } else if (deviceType(context) == Device.pc) {
      return pc;
    } else {
      return tv;
    }
  }

//* this method for extra control and making sure that there will be a widget that will be returned
//* so we made the pc and mobile widgets required

//* otherwise the class consumer doesn't need to use this class at all if he didn't provide a widget for mobile and pc
  Widget suitableWidget(BuildContext context) {
    return renderDeviceWidget(context) != null
        ? renderDeviceWidget(context)!
        //? instead of the next lines i need to provide the method that will provide the most suitable widget if the needed one is absent
        : (MediaQuery.of(context).size.width > breakpoints[Device.tablet]![1])
            ? pc ?? SizedBox()
            : mobile ?? SizedBox();
  }

//* isSmallScreen or isLargeScreen methods will be used in
//* things  such as deciding viewing side bar or not and things like that
//* the screen will be treated as small if it is tablet or smaller
  static bool isSmallScreen(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= breakpoints[smallScreen[0]]![0] &&
        width <= breakpoints[smallScreen[smallScreen.length - 1]]![1]) {
      return true;
    }
    return false;
  }

  static bool isMediumScreen(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= breakpoints[mediumScreen[0]]![0] &&
        width <= breakpoints[mediumScreen[mediumScreen.length - 1]]![1]) {
      return true;
    }
    return false;
  }

  //* the screen will be treated as large screen if it is larger than the tablet screen
  static bool isLargeScreen(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= breakpoints[largeScreen[0]]![0] &&
        width <= breakpoints[largeScreen[largeScreen.length - 1]]![1]) {
      return true;
    }
    return false;
  }

//* this takes percentage like 3, 4, 5, 3.5, 5.2
  static double textSize(BuildContext context, double size) {
    double width = getWidth(context);
    return (size * width) / 100;
  }

  @override
  Widget build(BuildContext context) {
    return suitableWidget(context);
  }
}
