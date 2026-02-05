import 'dart:ui' as ui;

import 'package:dentaltreatment/features/home/presentation/widgets/removebackground.dart';
import 'package:flutter/material.dart';

class CleanToothImage extends StatelessWidget {
  final String path;
  final double size;

  const CleanToothImage({super.key, required this.path, required this.size});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: removeBlackFromImage(path),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: size, height: size);
        }
        return RawImage(
          image: snapshot.data,
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
      },
    );
  }
}
