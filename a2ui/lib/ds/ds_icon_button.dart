import 'package:flutter/material.dart';

/// A reusable icon button following the design system.
class DsIconButton extends StatelessWidget {
  const DsIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 40,
    this.iconSize = 20,
    this.borderRadius = 8,
  });

  final double size;
  final double iconSize;
  final double borderRadius;

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    return Material(
      color: isEnabled
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: iconSize,
            color: isEnabled
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
