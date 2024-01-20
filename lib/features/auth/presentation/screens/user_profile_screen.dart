import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/index.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UsernameUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('user name updated successfully')),
          );
        }
        if (state is PhoneNumberUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number updated successfully')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: const Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'الحساب',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              // Wrap UserProfileBody with Expanded
              child: UserProfileBody(),
            ),
          ],
        ),
      ),
    );
  }
}
