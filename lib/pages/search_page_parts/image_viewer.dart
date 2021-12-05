import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final Image img;
  const ImageViewer({required this.img, Key? key}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final double minScale = 1;
  final double maxScale = 4;
  double scale = 1;
  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    return staticImage(context);
  }
  
  void showOverlay(BuildContext context) {
    entry = OverlayEntry(
      builder: (context) {
        return Stack(children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
          Positioned.fill(
            child: dynamicImage(context),
          ),
          Positioned(
            right: 30,
            top: 30,
            child: SizedBox(
              height: 30,
              width: 30,
              // color: Colors.red,
              child: TextButton(
                onPressed: removeOverlay,
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
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

  Widget dynamicImage(BuildContext context) {
    return InteractiveViewer(
      maxScale: maxScale,
      minScale: minScale,
      child: AspectRatio(
        aspectRatio: scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: widget.img,
        ),
      ),
    );
  }

  Widget staticImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showOverlay(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: widget.img,
      ),
      //   InteractiveViewer(
      //     transformationController: _controller,
      //     maxScale: maxScale,
      //     minScale: minScale,
      //     onInteractionStart: (details) {
      //       if (details.pointerCount < 2) return;
      //       showOverlay(context);
      //     },
      //     onInteractionUpdate: (details) {
      //       if (entry == null) return;
      //       scale = details.scale;
      //       entry!.markNeedsBuild();
      //     },
      //     // onInteractionEnd: (details) {
      //     //   resetAnimation();
      //     // },
      //     clipBehavior: Clip.none,
      //     child: AspectRatio(
      //       aspectRatio: 1,
      //       child: ClipRRect(
      //         borderRadius: BorderRadius.circular(20),
      //         child: widget.img,
      //       ),
      //     ),
      //   ),
    );
  }
}
