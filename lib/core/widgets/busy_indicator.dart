import 'package:flutter/material.dart';

/// A widget that shows a loading indicator.
///
/// This widget can be used to show a loading indicator when the app is busy,
/// such as when loading data from the network.
class BusyIndicator extends StatelessWidget {
  /// The size of the indicator. Defaults to 40.0.
  final double size;

  /// The color of the indicator. If null, uses the theme's primary color.
  final Color? color;

  /// Creates a new [BusyIndicator].
  const BusyIndicator({
    Key? key,
    this.size = 40.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
