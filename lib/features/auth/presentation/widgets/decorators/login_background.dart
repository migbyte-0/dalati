import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../../../../../core/constants/constants_exports.dart';
import '../../../../../core/shared/widgets/decorators/index.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: UpperWaveClipper(),
          child: const GradientContainer(
            myHeight: 230, //طول الشكل الاول
            firstGradientColor: AppColors.fourthColor,
            secondGradientColor: Color.fromARGB(255, 177, 221, 216),
          ),
        ),
        ClipPath(
          clipper: LowerWaveClipper(),
          child: const GradientContainer(
            myHeight: 220, //طول الشكل الثاني
            firstGradientColor: AppColors.thirdColor,
            secondGradientColor: Color.fromARGB(255, 19, 113, 107),
          ),
        ),
        ClipPath(
          clipper: WaveClipperOne(),
          child: const GradientContainer(
            myHeight: 150, //طول الشكل الثالث
            firstGradientColor: AppColors.secondaryColor,
            secondGradientColor: Color.fromARGB(255, 7, 61, 79),
          ),
        ),
        ClipPath(
          clipper: UpperWaveClipper(),
          child: const GradientContainer(
            myHeight: 100, //طول الشكل الرابع
            firstGradientColor: AppColors.primaryColor,
            secondGradientColor: Color.fromARGB(255, 3, 35, 48),
          ),
        ),
      ],
    );
  }
}
