import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? selectedCategory;
  String? username = 'Unknown';
  String? phoneNumber = 'No Contact';

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            username = userData.data()?['username'] ?? 'Unknown';
            phoneNumber = userData.data()?['phoneNumber'] ?? 'No Contact';
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
      builder: (BuildContext context) {
        return ItemEntryDialog(
          isLostItem: true,
          username: username ?? 'Unknown',
          phoneNumber: phoneNumber ?? 'No Contact',
          onItemAdded: _refreshItems,
        );
      },
    );
  }

  void _refreshItems() {
    setState(() {
      context
          .read<ItemBloc>()
          .add(LoadItems(isLostItem: true, category: selectedCategory));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Lost Items'),
      ),
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('مفقودات'), SizedBox(width: 8), Icon(Icons.abc)],
          ),
          Padding(
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
          ),
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return CategoriesGrid(
                  state: state,
                  onCategorySelected: (categoryName) {
                    setState(() {
                      selectedCategory = categoryName;
                      context.read<ItemBloc>().add(LoadItems(
                          isLostItem: true, category: selectedCategory));
                    });
                  },
                );
              },
            ),
          ),
          if (selectedCategory != null)
            Expanded(
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  return LostItemsList(state: state);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
