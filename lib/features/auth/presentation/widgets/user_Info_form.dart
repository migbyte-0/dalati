import 'package:dalati/core/constants/app_text.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants_exports.dart';
import 'decorators/decorators_exports.dart';
import 'user_input_fields.dart';
import 'validators/user_validators.dart';

//ويدجت لنموذج معلومات المستخدم
class UserInfoForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController phoneNumberController;
  final bool isPhoneNumberValid;
  final VoidCallback onFormSubmit;
  final Function(String) onPhoneNumberChanged;
  final GlobalKey<FormState> formKey;

  const UserInfoForm({
    Key? key,
    required this.usernameController,
    required this.phoneNumberController,
    required this.isPhoneNumberValid,
    required this.onFormSubmit,
    required this.onPhoneNumberChanged,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //خلفية شاشةإدخال اسم المستخدم ورقم الهاتف
        const UserEntryBackground(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //حقل اسم المستخدم
                UserInputField(
                  controller: usernameController,
                  hintText: AppTexts.userName,
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.name,
                  validator: UserInputValidators.validateUsername,
                  suffixIcon: IconButton(
                    onPressed: () {
                      usernameController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                  onChanged: (value) => usernameController.text = value,
                ),
                const SizedBox(height: 20),
                //حقل رقم الجوال
                UserInputField(
                  controller: phoneNumberController,
                  hintText: AppTexts.phoneNumber,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  suffixIcon: isPhoneNumberValid
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : IconButton(
                          onPressed: () {
                            phoneNumberController.clear();
                          },
                          icon: const Icon(
                            Icons.clear,
                          ),
                        ),
                  validator: UserInputValidators.validatePhoneNumber,
                  maxLength: 9,
                  onChanged: onPhoneNumberChanged,
                ),
                const SizedBox(height: 50),
                //زر الدخول إلى الصفحة الرئيسية
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onFormSubmit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    AppTexts.enter, //نص الدخول
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
