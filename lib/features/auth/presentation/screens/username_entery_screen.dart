import 'package:dalati/features/auth/presentation/bloc/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/index.dart';
import 'screens_exports.dart';

//شاشة إدخال اسم المستخدم وكلمة المرور
class UsernameEntryScreen extends StatefulWidget {
  const UsernameEntryScreen({Key? key}) : super(key: key);

  @override
  _UsernameEntryScreenState createState() => _UsernameEntryScreenState();
}

class _UsernameEntryScreenState extends State<UsernameEntryScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // Define a GlobalKey for FormState

  bool isLoading = false;
  bool isPhoneNumberValid = false;

  @override
  void dispose() {
    usernameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _updatePhoneNumberValidation(String value) {
    bool isValid = RegExp(r'^5\d{8}$').hasMatch(value);
    if (isValid != isPhoneNumberValid) {
      setState(() {
        isPhoneNumberValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UsernameUpdated || state is PhoneNumberUpdated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        setState(() => isLoading = false);
      },
      child: Scaffold(
        body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : UserInfoForm(
                    usernameController: usernameController,
                    phoneNumberController: phoneNumberController,
                    isPhoneNumberValid: isPhoneNumberValid,
                    onFormSubmit: _onFormSubmit,
                    onPhoneNumberChanged: _updatePhoneNumberValidation,
                    formKey: formKey, // Pass the formKey to UserInfoForm
                  )),
      ),
    );
  }

  void _onFormSubmit() async {
    // Reverse the phone number
    String reversedPhoneNumber = reversePhoneNumber(phoneNumberController.text);

    setState(() => isLoading = true);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    // Use reversedPhoneNumber instead of phoneNumberController.text
    await UserInformationManager.saveUserInfo(
        usernameController.text, reversedPhoneNumber);

    authBloc.add(UpdateUsernameEvent(usernameController.text));
    authBloc.add(UpdatePhoneNumberEvent(reversedPhoneNumber));
  }

  // Utility function to reverse a phone number
  String reversePhoneNumber(String phoneNumber) {
    // Step 1: Reverse the phone number
    String reversed = phoneNumber.split('').reversed.join();

    // Step 2: Check if the reversed number starts with '5'
    if (reversed.startsWith('5')) {
      return reversed;
    } else {
      // Step 3: Manipulate the string to make it start with '5'
      // This is a placeholder for whatever logic you need to apply
      // For example, you might need to add or replace a character
      reversed = '5${reversed.substring(1)}';
      return reversed;
    }
  }
}
