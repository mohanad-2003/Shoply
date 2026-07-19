import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Row of star icons rendering a fractional rating (0–5).
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size,
    this.count = 5,
  });

  final double rating;
  final double? size;
  final int count;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 16.r;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final filled = i + 1 <= rating;
        final half = !filled && i + 0.5 <= rating;
        return Icon(
          half
              ? Icons.star_half_rounded
              : filled
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
          color: AppColors.star,
          size: s,
        );
      }),
    );
  }
}
