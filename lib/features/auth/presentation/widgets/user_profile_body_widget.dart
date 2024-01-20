import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'edit_profile_dialog_widget.dart';

// In the UserProfileBody widget
class UserProfileBody extends StatelessWidget {
  const UserProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If the user is not found, simply return a not found message.
      return const Center(child: Text('User not found'));
    }

    // We initiate the fetching of user data here.
    final userDocumentFuture =
        FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UsernameUpdated || state is PhoneNumberUpdated) {
          // Notify the user that the profile has been updated successfully.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      },
      builder: (context, state) {
        if (state is UsernameUpdating || state is PhoneNumberUpdating) {
          // Show loading indicator while updating
          return const Center(child: CircularProgressIndicator());
        }
        // Else, show the profile data.
        return FutureBuilder<DocumentSnapshot>(
          future: userDocumentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while the user data is being fetched.
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data?.data() == null) {
              // If the snapshot has no data, show a message indicating this.
              return const Center(child: Text('User data not available'));
            }
            // Extract the user data from the snapshot.
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final String username = userData['username'] as String? ?? '';
            final String phoneNumber = userData['phoneNumber'] as String? ?? '';

            // Build a list view showing the user's profile data.
            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                _buildUserInformationCard(user, username, phoneNumber, context),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildUserInformationCard(
      User user, String username, String phoneNumber, BuildContext context) {
    String reversePhoneNumber(String phoneNumber) {
      return phoneNumber.split('').reversed.join();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('البريد الإلكتروني'),
            subtitle: Text(user.email ?? 'Not available'),
          ),
          const Divider(),
          _editableListTile('إسم المستخدم', username, context),
          const Divider(),
          _editableListTile(
              'رقم الهاتف', reversePhoneNumber(phoneNumber), context),
        ],
      ),
    );
  }

  Widget _editableListTile(String title, String value, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _showEditDialog(context, title, value),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, String title, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => EditProfileDialog(
        title: title,
        controller: controller,
        onUpdate: (newValue) async {
          // Trigger the corresponding event in the auth bloc.
          if (title == 'Username') {
            BlocProvider.of<AuthBloc>(context)
                .add(UpdateUsernameEvent(newValue));
          } else if (title == 'Phone Number') {
            BlocProvider.of<AuthBloc>(context)
                .add(UpdatePhoneNumberEvent(newValue));
          }
          // Wait for the bloc to process the update.
          await Future.delayed(const Duration(seconds: 2));
          // Close the dialog.
          Navigator.pop(context);
        },
      ),
    );
  }
}
