import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MouseCursorPainter extends CustomPainter {
  MouseCursorPainter({required this.offset, this.factor = 64.0});

  final Offset offset;
  final double factor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(offset.dx, offset.dy)
      ..lineTo(offset.dx, offset.dy + 48 * factor / 64)
      ..lineTo(offset.dx + 34 * factor / 64, offset.dy + 34 * factor / 64)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = ui.PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = ui.PaintingStyle.stroke
        ..strokeJoin = ui.StrokeJoin.miter
        ..strokeWidth = 3.5 * factor / 64,
    );
  }

  @override
  bool shouldRepaint(covariant MouseCursorPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}

class SoftwareMouseCursor extends StatelessWidget {
  SoftwareMouseCursor({Key? key, required this.child}) : super(key: key);

  final cursorPos = ValueNotifier(Offset.zero);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse) {
          cursorPos.value = event.position;
        }
      },
      onPointerMove: (event) {
        if (event.kind == PointerDeviceKind.mouse) {
          cursorPos.value = event.position;
        }
      },
      onPointerUp: (event) {
        if (event.kind == PointerDeviceKind.mouse) {
          cursorPos.value = event.position;
        }
      },
      onPointerHover: (event) {
        if (event.kind == PointerDeviceKind.mouse) {
          cursorPos.value = event.position;
        }
      },
      behavior: HitTestBehavior.translucent,
      child: ValueListenableBuilder<Offset>(
        valueListenable: cursorPos,
        builder: (context, pos, child) {
          return CustomPaint(
            foregroundPainter: MouseCursorPainter(
              offset: pos,
              factor: ui.window.devicePixelRatio * 64,
            ),
            child: child,
          );
        },
        child: RepaintBoundary(
          child: child,
        ),
      ),
    );
  }
}
