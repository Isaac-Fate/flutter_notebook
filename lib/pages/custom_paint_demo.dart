import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class CustomPaintDemo extends StatefulWidget {
  const CustomPaintDemo({super.key});

  @override
  State<CustomPaintDemo> createState() => _CustomPaintDemoState();
}

class _CustomPaintDemoState extends State<CustomPaintDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Paint Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Ring'),
            CustomPaint(
              painter: RingPainter(),
              size: const Size(50, 50), // You can adjust the size as needed
            ),
            const Text('Connet Two Rings'),
            CustomPaint(
              painter: TwoRingsPainter(),
              size: const Size(50, 50), // You can adjust the size as needed
            ),
          ],
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final Color ringColor;
  final double width;

  RingPainter({this.ringColor = Colors.blue, this.width = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ringColor
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TwoRingsPainter extends CustomPainter {
  final Color ringColor;
  final double width;

  TwoRingsPainter({this.ringColor = Colors.blue, this.width = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ringColor
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final center1 = Offset(0, 0);
    final center2 = Offset(100, 100);
    final radius = min(size.width, size.height) / 2;

    final endpoints =
        shortenSgment(center1, center2, distanceFromEndpoint: radius);
    final endpointFrom = endpoints.item1;
    final endpointTo = endpoints.item2;

    canvas.drawCircle(center1, radius, paint);
    canvas.drawCircle(center2, radius, paint);
    canvas.drawLine(endpointFrom, endpointTo, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Transforms the endpoints of a segment so that the it is shortened by the given distance.
Tuple2<Offset, Offset> shortenSgment(
  Offset endpointFrom,
  Offset endpointTo, {
  double distanceFromEndpoint = 0,
}) {
  // Calculate the angle between the two endpoints
  final angle = atan2(
    endpointTo.dy - endpointFrom.dy,
    endpointTo.dx - endpointFrom.dx,
  );

  // Transform the starting endpoint
  final endpointFromTransformed = Offset(
    endpointFrom.dx + cos(angle) * distanceFromEndpoint,
    endpointFrom.dy + sin(angle) * distanceFromEndpoint,
  );

  // Transform the ending endpoint
  final endpointToTransformed = Offset(
    endpointTo.dx - cos(angle) * distanceFromEndpoint,
    endpointTo.dy - sin(angle) * distanceFromEndpoint,
  );

  return Tuple2(endpointFromTransformed, endpointToTransformed);
}
