import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AppAnimateX on Widget {
  Widget pulse() =>
      animate(onPlay: (controller) => controller.repeat(reverse: true))
          .fade(begin: 0.4, end: 1, duration: 700.ms);

  Widget listItemAnimation(int index) =>
      animate(delay: (index.clamp(0, 8) * 50).ms)
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.08, end: 0, curve: Curves.easeOut);
  Widget fadeSlideIn({Duration delay = Duration.zero}) =>
      animate(delay: delay)
          .fadeIn(duration: 350.ms)
          .slideY(begin: 0.06, end: 0, curve: Curves.easeOut);

  Widget logoIntro({Duration delay = Duration.zero}) => animate(delay: delay)
      .fadeIn(duration: 600.ms)
      .scale(
        begin: const Offset(0.85, 0.85),
        end: const Offset(1, 1),
        curve: Curves.easeOutBack,
      );
}
