import 'package:flutter/material.dart';

enum ArrowPosition { top, bottom, none }

class DsPositionPopup extends StatefulWidget {
  final Widget child;
  final Offset targetPosition;
  final ArrowPosition arrowPosition;
  final double arrowSize;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final BoxShadow? shadow;
  final double distance;

  const DsPositionPopup({
    super.key,
    required this.child,
    required this.targetPosition,
    this.arrowPosition = ArrowPosition.top,
    this.arrowSize = 12,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.shadow,
    this.distance = 16,
  });

  @override
  State<DsPositionPopup> createState() => _DsPositionPopupState();
}

class _DsPositionPopupState extends State<DsPositionPopup> {
  final GlobalKey _childKey = GlobalKey();
  Size? _childSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSize();
    });
  }

  void _updateSize() {
    final RenderBox? renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        _childSize = renderBox.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;

    const double minMargin = 16.0;

    if (_childSize == null) {
      // First render: measure the child
      return Positioned(
        left: -10000, // Off-screen để measure
        top: -10000,
        child: Opacity(
          opacity: 0,
          child: Container(
            key: _childKey,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: widget.child,
          ),
        ),
      );
    }

    // Tính toán vị trí popup với safe area
    final calculatedPosition = _calculatePosition(
      screenSize: screenSize,
      safeArea: safeArea,
      minMargin: minMargin,
      popupWidth: _childSize!.width,
      popupHeight: _childSize!.height,
    );

    return Positioned(
      left: calculatedPosition.left,
      top: calculatedPosition.top,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (calculatedPosition.showArrow &&
              widget.arrowPosition == ArrowPosition.top)
            Padding(
              padding: EdgeInsets.only(left: calculatedPosition.arrowOffset),
              child: _buildArrow(),
            ),
          Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.shadow != null
                  ? [widget.shadow!]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Material(color: Colors.transparent, child: widget.child),
          ),
          if (calculatedPosition.showArrow &&
              widget.arrowPosition == ArrowPosition.bottom)
            Padding(
              padding: EdgeInsets.only(left: calculatedPosition.arrowOffset),
              child: _buildArrow(),
            ),
        ],
      ),
    );
  }

  _CalculatedPosition _calculatePosition({
    required Size screenSize,
    required EdgeInsets safeArea,
    required double minMargin,
    required double popupWidth,
    required double popupHeight,
  }) {
    // Tính toán vị trí left để popup nằm trong safe area
    double left = widget.targetPosition.dx - (popupWidth / 2);
    final double minLeft = safeArea.left + minMargin;
    final double maxLeft =
        screenSize.width - safeArea.right - minMargin - popupWidth;

    // Giới hạn left trong safe area
    if (left < minLeft) {
      left = minLeft;
    } else if (left > maxLeft) {
      left = maxLeft;
    }

    // Tính toán arrow offset (vị trí mũi tên so với cạnh trái của popup)
    double arrowOffset = widget.targetPosition.dx - left - (widget.arrowSize);
    arrowOffset = arrowOffset.clamp(
      widget.arrowSize,
      popupWidth - widget.arrowSize * 3,
    );

    // Tính toán vị trí top
    double top;
    bool showArrow = true;

    if (widget.arrowPosition == ArrowPosition.top) {
      // Popup hiển thị dưới target với khoảng cách distance
      top = widget.targetPosition.dy + widget.distance;
      final double maxTop =
          screenSize.height - safeArea.bottom - minMargin - popupHeight;

      if (top > maxTop) {
        // Không đủ chỗ, ưu tiên safe area
        top = maxTop;
        // Kiểm tra xem arrow có nằm ngoài target không
        if (top >
            widget.targetPosition.dy + widget.arrowSize + widget.distance) {
          showArrow = false; // Ẩn arrow nếu quá xa target
        }
      }
    } else if (widget.arrowPosition == ArrowPosition.bottom) {
      // Popup hiển thị trên target với khoảng cách distance
      top = widget.targetPosition.dy - popupHeight - widget.distance;
      final double minTop = safeArea.top + minMargin;

      if (top < minTop) {
        // Không đủ chỗ, ưu tiên safe area
        top = minTop;
        // Kiểm tra xem arrow có nằm ngoài target không
        if (top + popupHeight <
            widget.targetPosition.dy - widget.arrowSize - widget.distance) {
          showArrow = false; // Ẩn arrow nếu quá xa target
        }
      }
    } else {
      // ArrowPosition.none
      top = widget.targetPosition.dy;
      showArrow = false;
    }

    return _CalculatedPosition(
      left: left,
      top: top,
      arrowOffset: arrowOffset,
      showArrow: showArrow && widget.arrowPosition != ArrowPosition.none,
    );
  }

  Widget _buildArrow() {
    return CustomPaint(
      size: Size(widget.arrowSize * 2, widget.arrowSize),
      painter: _ArrowPainter(
        color: widget.backgroundColor,
        isPointingUp: widget.arrowPosition == ArrowPosition.bottom,
      ),
    );
  }
}

class _CalculatedPosition {
  final double left;
  final double top;
  final double arrowOffset;
  final bool showArrow;

  _CalculatedPosition({
    required this.left,
    required this.top,
    required this.arrowOffset,
    required this.showArrow,
  });
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final bool isPointingUp;

  _ArrowPainter({required this.color, required this.isPointingUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isPointingUp) {
      // Arrow pointing up (at bottom of popup)
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      // Arrow pointing down (at top of popup)
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);

    // Add shadow to arrow
    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 2, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Helper function to show popup on the screen
void showDsPositionPopup({
  required BuildContext context,
  required Widget child,
  required Offset position,
  ArrowPosition? arrowPosition,
  double arrowSize = 12,
  Color backgroundColor = Colors.white,
  double borderRadius = 12,
  EdgeInsets padding = const EdgeInsets.all(16),
  BoxShadow? shadow,
  VoidCallback? onDismiss,
  double distance = 16,
}) {
  final overlay = Overlay.of(context);
  final screenSize = MediaQuery.of(context).size;

  // Tự động xác định vị trí mũi tên dựa trên vị trí popup
  ArrowPosition finalArrowPosition =
      arrowPosition ?? _determineArrowPosition(position, screenSize);

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Backdrop to dismiss
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              overlayEntry.remove();
              onDismiss?.call();
            },
            child: Container(color: Colors.transparent),
          ),
        ),
        // Popup
        DsPositionPopup(
          targetPosition: position,
          arrowPosition: finalArrowPosition,
          arrowSize: arrowSize,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          padding: padding,
          shadow: shadow,
          distance: distance,
          child: child,
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);
}

/// Xác định vị trí mũi tên dựa trên vị trí popup trên màn hình
ArrowPosition _determineArrowPosition(Offset position, Size screenSize) {
  // Nếu popup ở nửa trên màn hình, mũi tên ở trên (pointing down)
  // Nếu popup ở nửa dưới màn hình, mũi tên ở dưới (pointing up)
  return position.dy < screenSize.height / 2
      ? ArrowPosition.top
      : ArrowPosition.bottom;
}

/// Extension để show popup dễ dàng hơn từ bất kỳ widget nào
extension DsPositionPopupExtension on BuildContext {
  void showPositionPopup({
    required Widget child,
    required Offset position,
    ArrowPosition? arrowPosition,
    double arrowSize = 12,
    Color backgroundColor = Colors.white,
    double borderRadius = 12,
    EdgeInsets padding = const EdgeInsets.all(16),
    BoxShadow? shadow,
    VoidCallback? onDismiss,
    double distance = 16,
  }) {
    showDsPositionPopup(
      context: this,
      child: child,
      position: position,
      arrowPosition: arrowPosition,
      arrowSize: arrowSize,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      padding: padding,
      shadow: shadow,
      onDismiss: onDismiss,
      distance: distance,
    );
  }
}
