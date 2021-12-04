import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final Image img;
  const ImageViewer({required this.img, Key? key}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _animationController;
  Animation<Matrix4>? animation;
  final double minScale = 1;
  final double maxScale = 4;
  double scale=1;
  OverlayEntry? entry;
  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 2000),
    )
      ..addListener(() => _controller.value = animation!.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          removeOverlay();
        }
      })
      ;
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildImage(context);
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: _controller.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceIn));
    _animationController.forward(from: 0);
  }

  void showOverlay(BuildContext context) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;
    entry = OverlayEntry(
      builder: (context) {
        final opacity = ((scale-1)/(maxScale-1)).clamp(0,1).toDouble();
        return Stack(children: [
          Positioned.fill(
            child: Opacity(
              opacity: opacity,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy,
            width: size.width,
            child: buildImage(context),
          ),
        ]);
      },
    );
    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }

  Widget buildImage(BuildContext context) {
    return InteractiveViewer(
      transformationController: _controller,
      maxScale: maxScale,
      minScale: minScale,
      onInteractionStart: (details) {
        if (details.pointerCount < 2) return;
        showOverlay(context);
      },
      onInteractionUpdate: (details) {
        if (entry==null) return;
        scale=details.scale;
        entry!.markNeedsBuild();
      },
      onInteractionEnd: (details) {
        resetAnimation();
      },
      clipBehavior: Clip.none,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: widget.img,
        ),
      ),
    );
  }
}
