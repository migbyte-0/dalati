import 'package:dalati/core/constants/constants_exports.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/shared/widgets/decorators/index.dart';

class LoginAvatar extends StatelessWidget {
  const LoginAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              //ظل
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: GradientIcon(
          firstGradientColor: AppColors.primaryColor,
          secondGradientColor: AppColors.appTeal,
          myChild: LottieBuilder.asset(
            // ملف لوقو صفحة التسجيل المتحرك

            'lib/assets/jsons/logo.json',
            repeat: false,
            height: 120,
            width: 120,
          ),
        ),
      ),
    );
  }
}
