import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBar extends StatelessWidget {
  final double correctPercentage;
  final double incorrectPercentage;

  const ProgressBar({
    super.key,
    required this.correctPercentage,
    required this.incorrectPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Row(
        children: [
          Expanded(
            flex: correctPercentage.round(),
            child: Container(
              color: Colors.green,
            ),
          ),
          Expanded(
            flex: incorrectPercentage.round(),
            child: Container(
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: (100 - correctPercentage - incorrectPercentage).round(),
            child: Container(
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
