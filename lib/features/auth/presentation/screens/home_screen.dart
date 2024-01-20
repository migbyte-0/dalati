import 'package:dalati/core/constants/constants_exports.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../item/presentation/screens/found_items_screen.dart';
import '../../../item/presentation/screens/lost_items_screen.dart';
import 'index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const LostItemsScreen(),
    const FoundItemsScreen(),
    const UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.infoColor,

        backgroundColor: Colors.transparent,
        elevation: 0, // Set elevation to zero

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.question_mark,
            ),
            icon: Icon(
              Icons.question_mark_outlined,
            ),
            label: 'المفقودات',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.search_outlined,
            ),
            icon: Icon(Icons.search),
            label: 'الموجودات',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
            ),
            icon: Icon(Icons.person_2_outlined),
            label: 'الحساب',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
