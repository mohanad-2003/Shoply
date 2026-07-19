import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Consistent app bar with an optional back button and action list.
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.centerTitle = true,
    this.leading,
  });

  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final bool centerTitle;
  final Widget? leading;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leading ??
          (showBack && Navigator.of(context).canPop()
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.r),
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                )
              : null),
      actions: actions,
    );
  }
}
