import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/widgets/decorators/index.dart';
import '../../../category/presentation/bloc/category_bloc.dart';
import '../bloc/item_bloc.dart';
import 'package:dalati/core/constants/constants_exports.dart';
import 'found_items_details_screen.dart';
import 'item_entry_dialog.dart'; // Import the dialog widget

class FoundItemsScreen extends StatefulWidget {
  const FoundItemsScreen({Key? key}) : super(key: key);

  @override
  _FoundItemsScreenState createState() => _FoundItemsScreenState();
}

class _FoundItemsScreenState extends State<FoundItemsScreen> {
  String? selectedCategory;
  String? username = 'Unknown';
  String? phoneNumber = 'No Contact';

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
    fetchUserProfile();
    // Listen to ItemBloc state changes
    context.read<ItemBloc>().stream.listen((state) {
      if (state is ItemAdded) {
        _refreshItems();
      }
    });
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
        // Handle the error appropriately
      }
    }
  }

  void _showAddItemDialog() {
    fetchUserProfile();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemEntryDialog(
          isLostItem: false,
          username: username ?? 'غير معروف',
          phoneNumber: phoneNumber ?? 'No Contact',
          onItemAdded: _refreshItems,
        );
      },
    );
  }

  void _refreshItems() {
    setState(() {
      // Request the ItemBloc to load items again
      //طلب البلوك المختص بي الاشياء الموجوده  بتحديث الشاشه لاظهار الاشياء الموجوده
      context
          .read<ItemBloc>()
          .add(LoadItems(isLostItem: false, category: selectedCategory));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('الموجودات'), SizedBox(width: 8), Icon(Icons.abc)],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'البحث عن الموجودات',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = category.name;
                            context.read<ItemBloc>().add(LoadItems(
                                isLostItem: false, category: selectedCategory));
                          });
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: GradientIcon(
                                  myChild: Image.network(category.imageUrl,
                                      scale: 3),
                                  firstGradientColor: AppColors.secondaryColor,
                                  secondGradientColor: AppColors.dangerColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(category.name),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                    child: Text("حدث خطأ, لم يتم العثور عللا أصناف"));
              },
            ),
          ),
          if (selectedCategory != null)
            Expanded(
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  if (state is ItemsLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ItemsLoaded) {
                    var foundItems =
                        state.items.where((item) => !item.isLostItem).toList();
                    if (foundItems.isEmpty) {
                      return const Text("لم يتم العثور على اي موجودات");
                    }
                    return ListView.builder(
                      itemCount: foundItems.length,
                      itemBuilder: (context, index) {
                        final item = foundItems[index];
                        return Card(
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    FoundItemDetailsScreen(item: item),
                              ),
                            ),
                            title: Text(item.category),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.description),
                                Text('عثر من قبل : ${item.name}'),
                                Text('رقم الهاتف: ${item.phoneNumber}'),
                                if (item.isClaimed)
                                  const Text('الحاله: ماخوذه',
                                      style: TextStyle(color: Colors.green)),
                                if (!item.isClaimed)
                                  const Text('الحاله: غير ماخوذه',
                                      style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Text("No items found or error occurred");
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
