import 'dart:math';

import 'package:a2ui/theme/app_colors.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

import '../utils/util.dart';

class DsButton extends StatelessWidget {
  final WidgetBuilder builder;

  const DsButton._({required this.builder});

  factory DsButton.primary({
    required String title,
    required VoidCallback? onPressed,
    double? width = double.infinity,
    Widget? prefix,
    Widget? suffix,
    bool isProgress = false,
  }) {
    return DsButton._(
      builder: (context) => SizedBox(
        height: 50.0,
        width: width,
        child: PrimaryButton(
          title: title,
          prefix: prefix,
          suffix: suffix,
          onPressed: onPressed,
          isProgress: isProgress,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  factory DsButton.smallPrimary({
    required String title,
    required VoidCallback? onPressed,
    double? width,
    Widget? prefix,
    Widget? suffix,
    bool isProgress = false,
  }) {
    return DsButton._(
      builder: (context) => SizedBox(
        height: 38.0,
        width: width,
        child: PrimaryButton(
          title: title,
          prefix: prefix,
          suffix: suffix,
          onPressed: onPressed,
          isProgress: isProgress,
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  factory DsButton.secondary({
    required String title,
    required VoidCallback? onPressed,
    double? width = double.infinity,
    Widget? prefix,
    Widget? suffix,
  }) {
    return DsButton._(
      builder: (context) => SizedBox(
        height: 50.0,
        width: width,
        child: SecondaryButton(
          title: title,
          prefix: prefix,
          suffix: suffix,
          onPressed: onPressed,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
  factory DsButton.outlined({
    required String title,
    required VoidCallback? onPressed,
    double? width = double.infinity,
    Widget? prefix,
    Widget? suffix,
  }) {
    return DsButton._(
      builder: (context) => SizedBox(
        height: 50.0,
        width: width,
        child: BorderButton(
          title: title,
          prefix: prefix,
          suffix: suffix,
          onPressed: onPressed,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  factory DsButton.smallSecondary({
    required String title,
    required VoidCallback? onPressed,
    double? width,
    Widget? prefix,
    Widget? suffix,
  }) {
    return DsButton._(
      builder: (context) => SizedBox(
        height: 38.0,
        width: width,
        child: SecondaryButton(
          title: title,
          prefix: prefix,
          suffix: suffix,
          onPressed: onPressed,
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  factory DsButton.destructive({
    required String title,
    required VoidCallback? onPressed,
    double? width = double.infinity,
    Widget? prefix,
    Widget? suffix,
    bool isProgress = false,
  }) {
    return DsButton._(
      builder: (context) => SizedBox(
        height: 50.0,
        width: width,
        child: DestructiveButton(
          title: title,
          prefix: prefix,
          suffix: suffix,
          onPressed: onPressed,
          isProgress: isProgress,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  factory DsButton.smallDestructive({
    required String title,
    required VoidCallback? onPressed,
    double? width,
    Widget? prefix,
    Widget? suffix,
    bool isProgress = false,
  }) {
    return DsButton._(
      builder: (context) => SizedBox(
        height: 38.0,
        width: width,
        child: DestructiveButton(
          title: title,
          prefix: prefix,
          suffix: suffix,
          onPressed: onPressed,
          isProgress: isProgress,
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: builder);
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.borderRadius = 8.0,
    required this.textStyle,
    this.prefix,
    this.suffix,
    this.isProgress = false,
  });
  final String title;
  final Function()? onPressed;
  final double borderRadius;
  final TextStyle textStyle;
  final Widget? prefix;
  final Widget? suffix;
  final bool isProgress;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: _DsButtonContent(
        title: title,
        style: textStyle,
        prefix: prefix,
        suffix: suffix,
        isProgress: isProgress,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.borderRadius = 8.0,
    required this.textStyle,
    this.prefix,
    this.suffix,
    this.isProgress = false,
  });
  final String title;
  final Function()? onPressed;
  final double borderRadius;
  final TextStyle textStyle;
  final Widget? prefix;
  final Widget? suffix;
  final bool isProgress;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.n900),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.n0),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            side: BorderSide(color: AppColors.n40),
          ),
        ),
      ),
      child: _DsButtonContent(
        title: title,
        style: textStyle,
        prefix: prefix,
        suffix: suffix,
        isProgress: isProgress,
      ),
    );
  }
}

class DestructiveButton extends StatelessWidget {
  const DestructiveButton({
    super.key,
    required this.title,
    this.onPressed,
    this.borderRadius = 8.0,
    required this.textStyle,
    this.prefix,
    this.suffix,
    this.isProgress = false,
  });
  final String title;
  final Function()? onPressed;
  final double borderRadius;
  final TextStyle textStyle;
  final Widget? prefix;
  final Widget? suffix;
  final bool isProgress;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.r50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _DsButtonContent(
        title: title,
        style: textStyle.copyWith(color: AppColors.r300),
        prefix: prefix,
        suffix: suffix,
        isProgress: isProgress,
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  const BorderButton({
    super.key,
    required this.title,
    this.onPressed,
    this.borderRadius = 8.0,
    required this.textStyle,
    this.prefix,
    this.suffix,
    this.isProgress = false,
  });
  final String title;
  final Function()? onPressed;
  final double borderRadius;
  final TextStyle textStyle;
  final Widget? prefix;
  final Widget? suffix;
  final bool isProgress;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.p100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(color: AppColors.p300),
      ),
      child: _DsButtonContent(
        title: title,
        style: textStyle.copyWith(color: AppColors.p300),
        prefix: prefix,
        suffix: suffix,
        isProgress: isProgress,
      ),
    );
  }
}

class _DsButtonContent extends StatelessWidget {
  const _DsButtonContent({
    required this.title,
    required this.style,
    this.prefix,
    this.suffix,
    this.isProgress = false,
  });
  final String title;
  final TextStyle style;
  final Widget? prefix;
  final Widget? suffix;
  final bool isProgress;
  @override
  Widget build(BuildContext context) {
    if (isProgress) {
      return const Center(child: CupertinoActivityIndicator());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefix != null)
          Padding(padding: const EdgeInsets.only(right: 4), child: prefix),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        if (suffix != null)
          Padding(padding: const EdgeInsets.only(left: 4), child: suffix),
      ],
    );
  }
}

class DsPinnedBottom extends StatelessWidget {
  final Widget child;

  const DsPinnedBottom({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.0,
        12.0,
        16.0,
        max(12.0, context.viewPadding.bottom + 2.0),
      ),
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(
            width: 1.0,
            color: Color.fromARGB(100, 120, 121, 121),
          ),
        ),
        color: AppColors.n0,
      ),
      child: child,
    );
  }
}

class DsPinnedTwoButton extends StatelessWidget {
  const DsPinnedTwoButton({super.key, required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return DsPinnedBottom(
      child: Row(
        children: [
          Expanded(child: left),
          sizedBoxW12,
          Expanded(child: right),
        ],
      ),
    );
  }
}

class SecondaryButton2 extends StatelessWidget {
  const SecondaryButton2({
    super.key,
    required this.title,
    this.onPressed,
    this.borderRadius = 8.0,
    required this.textStyle,
    this.prefix,
    this.suffix,
    this.isProgress = false,
  });
  final String title;
  final Function()? onPressed;
  final double borderRadius;
  final TextStyle textStyle;
  final Widget? prefix;
  final Widget? suffix;
  final bool isProgress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(AppColors.p300),
          backgroundColor: WidgetStateProperty.all<Color>(AppColors.n0),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              side: BorderSide(color: AppColors.n40),
            ),
          ),
        ),
        child: _DsButtonContent(
          title: title,
          style: textStyle,
          prefix: prefix,
          suffix: suffix,
          isProgress: isProgress,
        ),
      ),
    );
  }
}
