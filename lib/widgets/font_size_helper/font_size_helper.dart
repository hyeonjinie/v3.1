import 'package:flutter/material.dart';

enum FontSizeType { extraLarge, large, medium, small, extraSmall }
enum ButtonSizeType { large, medium, small, extraSmall }

double getFontSize(BuildContext context, FontSizeType type) {
  double screenWidth = MediaQuery.of(context).size.width;

  switch (type) {
    case FontSizeType.extraLarge:
      return screenWidth > 1200
          ? 32
          : screenWidth > 800
          ? 28
          : screenWidth > 600
          ? 24
          : screenWidth > 400
          ? 22
          : 20;
    case FontSizeType.large:
      return screenWidth > 1200
          ? 28
          : screenWidth > 800
          ? 24
          : screenWidth > 600
          ? 20
          : screenWidth > 400
          ? 18
          : 16;
    case FontSizeType.medium:
      return screenWidth > 1200
          ? 22
          : screenWidth > 800
          ? 20
          : screenWidth > 600
          ? 18
          : screenWidth > 400
          ? 16
          : 14;
    case FontSizeType.small:
      return screenWidth > 1200
          ? 18
          : screenWidth > 800
          ? 16
          : screenWidth > 600
          ? 14
          : screenWidth > 400
          ? 12
          : 10;
    case FontSizeType.extraSmall:
      return screenWidth > 1200
          ? 16
          : screenWidth > 800
          ? 14
          : screenWidth > 600
          ? 12
          : screenWidth > 400
          ? 10
          : 6;
    default:
      return 16; // 기본값
  }
}

Size getButtonSize(BuildContext context, ButtonSizeType type) {
  double screenWidth = MediaQuery.of(context).size.width;

  switch (type) {
    case ButtonSizeType.large:
      return screenWidth > 1200
          ? const Size(200, 60)
          : screenWidth > 800
          ? const Size(180, 55)
          : screenWidth > 600
          ? Size(160, 50)
          : screenWidth > 400
          ? Size(140, 45)
          : Size(120, 40);
    case ButtonSizeType.medium:
      return screenWidth > 1200
          ? Size(160, 50)
          : screenWidth > 800
          ? Size(140, 45)
          : screenWidth > 600
          ? Size(120, 40)
          : screenWidth > 400
          ? Size(100, 35)
          : Size(80, 30);
    case ButtonSizeType.small:
      return screenWidth > 1200
          ? Size(120, 40)
          : screenWidth > 800
          ? Size(100, 35)
          : screenWidth > 600
          ? Size(80, 30)
          : screenWidth > 400
          ? Size(70, 25)
          : Size(60, 20);
    case ButtonSizeType.extraSmall:
      return screenWidth > 1200
          ? Size(100, 35)
          : screenWidth > 800
          ? Size(90, 30)
          : screenWidth > 600
          ? Size(80, 25)
          : screenWidth > 400
          ? Size(70, 20)
          : Size(60, 15);
    default:
      return Size(100, 35); // 기본값
  }
}
