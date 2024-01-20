import 'package:dalati/core/constants/constants_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';

//زر تسجيل الدخول عبر قوقل
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            AppTexts.loginWithGoogle, //نص تسجيل الدخول عبر قوقل
            style: Styles.style16,
          ),
          const SizedBox(width: 10), //أضافة مساحه بين شعار قوقل والنص
          Image.asset(
            ImageAssets.googleLogo, //مسار صورة شعار قوقل
            height: 24, // حجم الشعار
            width: 24, // حجم الشعار
          ),
        ],
      ),
    );
  }
}
