import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(
      size: 100,
      color: Theme.of(context).accentColor,
    );
  }
}
