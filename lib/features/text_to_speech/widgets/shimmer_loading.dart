import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عناصر الشيمر للمحاكاة
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity * 0.8,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity * 0.7,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity * 0.9,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity * 0.6,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity * 0.8,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity * 0.7,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
