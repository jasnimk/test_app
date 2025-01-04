import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

enum SpinkitType {
  circle,
  fadingCube,
  wave,
  fadingGrid,
  chasingDots,
  pulse,
  dualRing,
  squareCircle,
  rotatingPlain,
  fadingFour,
  threeBounce,
  cubeGrid,
}

Widget customSpinkitLoaderWithType({
  required BuildContext context,
  SpinkitType type = SpinkitType.circle,
  Color color = Colors.blue,
  double size = 50.0,
}) {
  switch (type) {
    case SpinkitType.fadingCube:
      return SpinKitFadingCube(color: color, size: size);
    case SpinkitType.wave:
      return SpinKitWave(color: color, size: size);
    case SpinkitType.fadingGrid:
      return SpinKitFadingGrid(color: color, size: size);
    case SpinkitType.chasingDots:
      return SpinKitChasingDots(color: color, size: size);
    case SpinkitType.pulse:
      return SpinKitPulse(color: color, size: size);
    case SpinkitType.dualRing:
      return SpinKitDualRing(color: color, size: size);
    case SpinkitType.squareCircle:
      return SpinKitSquareCircle(color: color, size: size);
    case SpinkitType.rotatingPlain:
      return SpinKitRotatingPlain(color: color, size: size);
    case SpinkitType.fadingFour:
      return SpinKitFadingFour(color: color, size: size);
    case SpinkitType.threeBounce:
      return SpinKitThreeBounce(color: color, size: size);
    case SpinkitType.cubeGrid:
      return SpinKitCubeGrid(color: color, size: size);
    default:
      return SpinKitCircle(color: color, size: size);
  }
}

buildLoadingIndicator({
  required BuildContext context,
  SpinkitType type = SpinkitType.threeBounce,
  Color color = const Color.fromARGB(255, 241, 241, 241),
  double size = 30.0,
}) {
  return Center(
    child: customSpinkitLoaderWithType(
      context: context,
      type: type,
      color: color,
      size: size,
    ),
  );
}

buildEmptyStateWidget({
  required String message,
  String? subMessage,
  String? imagePath,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
            imagePath ?? 'assets/animations/Animation - 1735364832916.json'),
        Text(message, style: AppTextStyles.bodyText.copyWith(fontSize: 14)),
        if (subMessage != null)
          Text(subMessage,
              style: AppTextStyles.bodyText.copyWith(fontSize: 14)),
      ],
    ),
  );
}
