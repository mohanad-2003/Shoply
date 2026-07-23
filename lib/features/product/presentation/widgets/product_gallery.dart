import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/theme/app_radius.dart';


class ProductGallery extends StatefulWidget {
  const ProductGallery({super.key, required this.images});

  final List<String> images;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => Container(
              color: context.colors.surfaceContainerHighest,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Image.asset(
                  widget.images[i],
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.image_outlined,
                    size: 64.r,
                    color: context.colors.outline,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: i == _index ? 18.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: i == _index
                    ? context.colors.primary
                    : context.colors.outlineVariant,
                borderRadius: AppRadius.rPill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
