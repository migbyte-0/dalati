import '../../../../../core/constants/constants_exports.dart';

class UserInputValidators {
  //التحقق من صحة إسم المستدم
  static String? validateUsername(String? value) {
    //(إذا كان حقل إسم المستخدم فارغ إظهار نص او رسالة (الرجاء إدخال اسم المستخدم"
    if (value == null || value.isEmpty) {
      return AppTexts.userNameEmpty; //رسالة الخطأ
    }

    //إذا كان  حقل إسم المستخدم اقل من 4 حروف إظهار خطأ (اسم المستخدم يجب أن يكون 4 أحرف على الأقل)"
    if (value.length < 4) {
      return AppTexts.userNameTooShort; //رسالة الخطأ
    }

    //(إذا كان  حقل إسم المستخدم يحتوي على ارقام إظهار خطأ (يجب أن يحتوي اسم المستخدم على حروف فقط"
    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\u0750-\u077F\s]+$').hasMatch(value)) {
      return AppTexts.invalidUsername; //رسالة الخطأ
    }
    return null;
  }

  //إذا كان حقل رقم الجوال فارغ إظهار خطأ (الرجاء إدخال رقم الهاتف)""
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.phoneNumberEmpty; //رسالة الخطأ
    }

    //إذا كان حقل رقم الجوال لا يبدا بالرقم 5 ولا يتكون من 9 ارقام إظهار خطأ (يجب أن يبدأ رقم الهاتف بـ 5 ويتكون من 9 أرقام)""
    if (!RegExp(r'^5\d{8}$').hasMatch(value)) {
      return AppTexts.invalidPhoneNumber; //رسالة الخطأ
    }
    return null;
  }
}
