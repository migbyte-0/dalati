import 'package:dalati/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/exports.dart';
import '../widgets/decorators/decorators_exports.dart';
import '../widgets/index.dart';

//شاشة تسجيل الدخول عبر قوقل
class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: AppColors.appGreyColor,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            //لوقو صفحة التسجيل المتحرك
                            child: LoginAvatar(),
                          ),
                          const SizedBox(height: 30),
                          //زر تسجيل الدخول عبر قوقل
                          GoogleSignInButton(
                            onPressed: () {
                              authBloc.add(SignInWithGoogleEvent());
                            },
                          ),
                          //
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              // إذا كانت الحاله هي التصديق في الإنتظار إظهار علامة التحميل
                              if (state is AuthLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          //
                        ],
                      ),
                    ),
                  ),
                ),
                //خلفية تسجيل الدخول
                const LoginBackground(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
