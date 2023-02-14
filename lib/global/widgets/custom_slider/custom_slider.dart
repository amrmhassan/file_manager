import 'package:flutter/material.dart';

import 'circle_model.dart';
import 'slider_painter.dart';
import 'sub_range_model.dart';

CustomCircle defaultThumb = const CustomCircle(color: Colors.red, radius: 10);

class CustomSlider extends StatefulWidget {
  final double listeningAreaHeigh;
  final Color? listeningAreaColor;
  final double min;
  final double max;
  final double value;
  final Function(double v) onChanged;
  final double activeThickness;
  final double inactiveThickness;
  final Color activeColor;
  final Color inactiveColor;
  final List<SubRangeModel>? subRanges;
  final List<CustomCircle>? thumbs;
  final double widthFactor;

  const CustomSlider({
    super.key,
    this.listeningAreaColor,
    this.listeningAreaHeigh = 50,
    this.activeThickness = 4,
    this.inactiveThickness = 2,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.white,
    this.subRanges,
    this.widthFactor = .9,
    this.thumbs,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider>
    with WidgetsBindingObserver {
  GlobalKey globalKey = GlobalKey();
  double width = 0;

  void handleComputeSliderData() {
    if (widget.value > widget.max || widget.value < widget.min) {
      throw Exception('initialValue should be >= min && <= max');
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          width = globalKey.currentContext!.size!.width;
        });
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    handleComputeSliderData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    handleComputeSliderData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeMetrics() {
    handleComputeSliderData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // this is the adjacent value that i will be using in the class, to distribute the size of the outer range over the slider actual size
  double get innerValue => valueEncode(widget.value);

  // this is the range that the user wants
  double get range => widget.max - widget.min;

  // this is the range that we want in this widget for our calculations
  double get size => width;

  // this will decode the used value in our slider to the actual value that the user needs
  double valueDecode(double dx) =>
      double.parse((((dx * range) / size) + widget.min).toStringAsFixed(4));

  // this will do the opposite=> to transform the value from the perspective of the user into ours
  double valueEncode(double v) => (v * width) / range;

  // when the slider is moved
  void handleValueChanged(Offset localPosition) {
    double dx = localPosition.dx;
    if (dx < 0) {
      dx = 0;
    } else if (dx > width) {
      dx = width;
    }
    if (dx == innerValue) return;
    widget.onChanged(valueDecode(dx));
  }

  // ranges transformer into our scale
  List<SubRangeModel> get innerSubRanges => [
        ...(widget.subRanges?.map(
              (e) => SubRangeModel(
                start: valueEncode(e.start),
                end: valueEncode(e.end),
                color: e.color,
              ),
            ) ??
            [])
      ];

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widget.widthFactor,
      child: GestureDetector(
        key: globalKey,
        onPanUpdate: (details) => handleValueChanged(details.localPosition),
        onTapDown: (details) => handleValueChanged(details.localPosition),
        child: Container(
          color: widget.listeningAreaColor ?? Colors.transparent,
          height: widget.listeningAreaHeigh,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            foregroundPainter: SliderPainter(
              thickness: widget.activeThickness,
              value: innerValue,
              activeColor: widget.activeColor,
              activeThickness: widget.activeThickness,
              thumbs: widget.thumbs ?? [defaultThumb],
              inactiveColor: widget.inactiveColor,
              inactiveThickness: widget.inactiveThickness,
              subRanges: innerSubRanges,
            ),
          ),
        ),
      ),
    );
  }
}
