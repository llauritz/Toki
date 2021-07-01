import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class Sprite extends StatefulWidget {
  final ImageProvider image;
  final int frameWidth;
  final int frameHeight;
  final num frame;

  Sprite({Key? key, required this.image, required this.frameWidth, required this.frameHeight, this.frame = 0}) : super(key: key);

  @override
  _SpriteState createState() => _SpriteState();
}

class _SpriteState extends State<Sprite> {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void didUpdateWidget(Sprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _getImage();
    }
  }

  void _getImage() {
    final ImageStream? oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    if (_imageStream?.key == oldImageStream?.key) {
      return;
    }
    final ImageStreamListener listener = ImageStreamListener(_updateImage);
    oldImageStream?.removeListener(listener);
    _imageStream?.addListener(listener);
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _imageInfo = imageInfo;
    });
  }

  @override
  void dispose() {
    _imageStream?.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageInfo == null) {
      return SizedBox();
    }
    ui.Image img = _imageInfo!.image;
    int w = img.width, frame = widget.frame.round();
    int frameW = widget.frameWidth, frameH = widget.frameHeight;
    int cols = (w / frameW).floor();
    int col = frame % cols, row = (frame / cols).floor();
    ui.Rect rect = ui.Rect.fromLTWH(col * frameW * 1.0, row * frameH * 1.0, frameW * 1.0, frameH * 1.0);
    return CustomPaint(painter: _SpritePainter(img, rect));
  }
}

class _SpritePainter extends CustomPainter {
  ui.Image image;
  ui.Rect rect;

  _SpritePainter(this.image, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(image, rect, ui.Rect.fromLTWH(0.0, 0.0, size.width, size.height), Paint());
  }

  @override
  bool shouldRepaint(_SpritePainter oldPainter) {
    return oldPainter.image != image || oldPainter.rect != rect;
  }
}

class AnimatedSprite extends AnimatedWidget {
  final ImageProvider image;
  final int frameWidth;
  final int frameHeight;

  AnimatedSprite({
    Key? key,
    required this.image,
    required this.frameWidth,
    required this.frameHeight,
    required Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Sprite(
      image: image,
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      frame: animation.value,
    );
  }
}
