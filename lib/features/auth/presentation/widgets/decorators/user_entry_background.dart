import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../../../../../core/constants/constants_exports.dart';
import '../../../../../core/shared/widgets/decorators/index.dart';

class UserEntryBackground extends StatelessWidget {
  final double heightOffset;

  const UserEntryBackground({
    Key? key,
    this.heightOffset = 10, // Default height offset
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipperOne(),
          child: GradientContainer(
            myHeight: MediaQuery.of(context).size.height - heightOffset,
            firstGradientColor: AppColors.secondaryColor,
            secondGradientColor: AppColors.secondaryColor,
          ),
        ),
        ClipPath(
          clipper: UpperWaveClipper(),
          child: GradientContainer(
            myHeight: MediaQuery.of(context).size.height,
            firstGradientColor: AppColors.primaryColor,
            secondGradientColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
