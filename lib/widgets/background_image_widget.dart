import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatefulWidget {
  final Widget child;
  final BoxFit fit;
  final double? opacity;
  final double overlayOpacity;

  const BackgroundImageWidget({
    super.key,
    required this.child,
    this.fit = BoxFit.cover,
    this.opacity = 1.0,
    this.overlayOpacity = 0.5,
  });

  @override
  State<BackgroundImageWidget> createState() => _BackgroundImageWidgetState();

}

class _BackgroundImageWidgetState extends State<BackgroundImageWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start the animation and make it repeat back and forth
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image with zoom animation
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Opacity(
                  opacity: widget.opacity!,
                  child: Image.asset(
                    'assets/images/onboarding-1.png',
                    fit: widget.fit,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        // Black Overlay
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(widget.overlayOpacity),
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}