// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class SpinningCloudWidget extends StatefulWidget {
  const SpinningCloudWidget({super.key});

  @override
  _SpinningCloudWidgetState createState() => _SpinningCloudWidgetState();
}

class _SpinningCloudWidgetState extends State<SpinningCloudWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14,
                child: child,
              );
            },
            child: const Icon(
              Icons.cloud,
              color: Colors.white,
              size: 80,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
