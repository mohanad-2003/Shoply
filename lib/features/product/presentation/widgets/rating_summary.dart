import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../domain/entities/review_entity.dart';

class RatingSummary extends StatelessWidget {
  const RatingSummary({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
  });

  final double rating;
  final int reviewCount;
  final List<ReviewEntity> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(rating.toStringAsFixed(1),
                style: context.textTheme.headlineMedium),
            SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingStars(rating: rating, size: 16.r),
                SizedBox(height: 2.h),
                Text('$reviewCount ${context.l10n.reviews}',
                    style: context.textTheme.bodySmall),
              ],
            ),
          ],
        ),
        SizedBox(height: AppSpacing.vLg),
        ...reviews.map((r) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.vMd),
              child: _ReviewTile(review: r),
            )),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: AppRadius.rMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: context.colors.primaryContainer,
                child: Text(
                  review.author.characters.first,
                  style: context.textTheme.labelLarge,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(review.author,
                    style: context.textTheme.titleMedium),
              ),
              Text(review.timeAgo, style: context.textTheme.labelSmall),
            ],
          ),
          SizedBox(height: AppSpacing.vSm),
          RatingStars(rating: review.rating, size: 13.r),
          SizedBox(height: AppSpacing.vSm),
          Text(review.comment, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
