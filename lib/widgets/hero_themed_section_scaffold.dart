import 'package:flutter/material.dart';
import 'package:payroute_desktop/widgets/hero_theme_background.dart';

/// Wraps any landing section with the same noir/teal hero backdrop.
///
/// This keeps all vertical PageView sections visually consistent with the
/// first hero screen (teal gradient + Africa map + animated network lines).
class HeroThemedSectionScaffold extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool useSafeArea;

  const HeroThemedSectionScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
    this.useSafeArea = true,
  });

  @override
  State<HeroThemedSectionScaffold> createState() => _HeroThemedSectionScaffoldState();
}

class _HeroThemedSectionScaffoldState extends State<HeroThemedSectionScaffold> with TickerProviderStateMixin {
  late final AnimationController _lines;
  late final AnimationController _breathe;

  @override
  void initState() {
    super.initState();
    _lines = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _breathe = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _lines.dispose();
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: widget.padding, child: widget.child);
    if (widget.useSafeArea) content = SafeArea(child: content);

    return Stack(
      fit: StackFit.expand,
      children: [
        HeroThemeBackground(linesAnimation: _lines, breathe: _breathe),
        content,
      ],
    );
  }
}
