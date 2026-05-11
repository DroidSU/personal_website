import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const HoverButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered 
          ? Matrix4.translationValues(0, -2, 0) 
          : Matrix4.identity(),
        child: widget.isPrimary
            ? ElevatedButton.icon(
                onPressed: widget.onPressed,
                icon: Icon(widget.icon ?? Icons.arrow_forward, size: 18),
                label: Text(widget.text),
              )
            : OutlinedButton.icon(
                onPressed: widget.onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(widget.icon ?? Icons.download, size: 18),
                label: Text(widget.text),
              ),
      ),
    ).animate(target: _isHovered ? 1 : 0).scale(
          end: const Offset(1.05, 1.05),
          curve: Curves.easeOutCubic,
        );
  }
}
