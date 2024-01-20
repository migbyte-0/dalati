import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../category/presentation/bloc/category_bloc.dart';
import '../widgets/category_grid.dart';
import '../bloc/item_bloc.dart';
import '../widgets/lost_items_list.dart';
import 'item_entry_dialog.dart';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({Key? key}) : super(key: key);

  @override
  _LostItemsScreenState createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  String? _selectedCategory;
  String? _username = 'Unknown';
  String? _phoneNumber = 'No Contact';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    context.read<CategoryBloc>().add(LoadCategories());
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            _username = userData.data()?['username'] ?? 'Unknown';
            _phoneNumber = userData.data()?['phoneNumber'] ?? 'No Contact';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (_) => ItemEntryDialog(
        isLostItem: true,
        username: _username ?? 'Unknown',
        phoneNumber: _phoneNumber ?? 'No Contact',
        onItemAdded: _refreshItems,
      ),
    );
  }

  void _refreshItems() {
    setState(() {
      context
          .read<ItemBloc>()
          .add(LoadItems(isLostItem: true, category: _selectedCategory));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow(),
        _buildSearchField(),
        _buildCategoriesGrid(),
        if (_selectedCategory != null) _buildLostItemsList(),
      ],
    );
  }

  Row _buildTitleRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('مفقودات'),
        SizedBox(width: 8),
        Icon(Icons.question_mark)
      ],
    );
  }

  Padding _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'البحث عن مفقودات',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Expanded _buildCategoriesGrid() {
    return Expanded(
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (_, state) => CategoriesGrid(
          state: state,
          onCategorySelected: (categoryName) {
            setState(() {
              _selectedCategory = categoryName;
              _refreshItems(); // Refresh items when a category is selected
            });
          },
        ),
      ),
    );
  }

  Expanded _buildLostItemsList() {
    return Expanded(
      child: BlocBuilder<ItemBloc, ItemState>(
        builder: (_, state) => LostItemsList(state: state),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: Colors.teal,
      onPressed: _showAddItemDialog,
      child: LottieBuilder.asset(
        'lib/assets/jsons/add.json',
        height: 100,
        width: 200,
        repeat: false,
      ),
    );
  }
}
