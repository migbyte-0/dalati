// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/shared/widgets/decorators/index.dart';
// import '../../../category/presentation/bloc/category_bloc.dart';
// import '../bloc/item_bloc.dart';
// import 'package:dalati/core/constants/constants_exports.dart';
// import 'item_entry_dialog.dart';
// import 'package:intl/intl.dart' as intl;
// import 'lost_items_details_screen.dart';

// class LostItemsScreen extends StatefulWidget {
//   const LostItemsScreen({Key? key}) : super(key: key);

//   @override
//   _LostItemsScreenState createState() => _LostItemsScreenState();
// }

// class _LostItemsScreenState extends State<LostItemsScreen> {
//   String? selectedCategory;
//   String? username = 'Unknown';
//   String? phoneNumber = 'No Contact';

//   @override
//   void initState() {
//     super.initState();
//     context.read<CategoryBloc>().add(LoadCategories());
//     fetchUserProfile();
//     context.read<ItemBloc>().stream.listen((state) {
//       if (state is ItemAdded) {
//         _refreshItems();
//       }
//     });
//   }

//   void fetchUserProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         var userData = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();

//         if (userData.exists) {
//           setState(() {
//             username = userData.data()?['username'] ?? 'Unknown';
//             phoneNumber = userData.data()?['phoneNumber'] ?? 'No Contact';
//           });
//         }
//       } catch (e) {
//         print("Error fetching user data: $e");
//       }
//     }
//   }

//   void _showAddItemDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return ItemEntryDialog(
//           isLostItem: true,
//           username: username ?? 'Unknown',
//           phoneNumber: phoneNumber ?? 'No Contact',
//           onItemAdded: _refreshItems,
//         );
//       },
//     );
//   }

//   void _refreshItems() {
//     setState(() {
//       context
//           .read<ItemBloc>()
//           .add(LoadItems(isLostItem: true, category: selectedCategory));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [Text('مفقودات'), SizedBox(width: 8), Icon(Icons.abc)],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.search),
//                 hintText: 'البحث عن مفقودات',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
//               decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(20)),
//               child: BlocBuilder<CategoryBloc, CategoryState>(
//                 builder: (context, state) {
//                   if (state is CategoryLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is CategoryLoaded) {
//                     return GridView.builder(
//                       padding: const EdgeInsets.all(15),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         childAspectRatio: 1,
//                         crossAxisSpacing: 25,
//                         mainAxisSpacing: 25,
//                       ),
//                       itemCount: state.categories.length,
//                       itemBuilder: (context, index) {
//                         final category = state.categories[index];
//                         return InkWell(
//                           onTap: () {
//                             setState(() {
//                               selectedCategory = category.name;
//                               context.read<ItemBloc>().add(LoadItems(
//                                   isLostItem: true,
//                                   category: selectedCategory));
//                             });
//                           },
//                           child: Card(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: GradientIcon(
//                                     myChild: Image.network(category.imageUrl,
//                                         scale: 3),
//                                     firstGradientColor:
//                                         AppColors.secondaryColor,
//                                     secondGradientColor: AppColors.dangerColor,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(category.name),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                   return const Center(
//                       child: Text("Error or no categories found"));
//                 },
//               ),
//             ),
//           ),
//           if (selectedCategory != null)
//             Expanded(
//               child: BlocBuilder<ItemBloc, ItemState>(
//                 builder: (context, state) {
//                   if (state is ItemsLoading) {
//                     return const CircularProgressIndicator();
//                   } else if (state is ItemsLoaded) {
//                     var lostItems = state.items;
//                     if (lostItems.isEmpty) {
//                       return const Text("No items found.");
//                     }
//                     return ListView.builder(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 20, horizontal: 15),
//                       itemCount: lostItems.length,
//                       itemBuilder: (context, index) {
//                         final item = lostItems[index];
//                         final dateFormat = intl.DateFormat('yyyy-MM-dd');
//                         final formattedDate = dateFormat.format(item.timestamp);
//                         return Card(
//                           child: ListTile(
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       LostItemDetailsScreen(item: item),
//                                 ),
//                               );
//                             },
//                             title: Row(
//                               children: [
//                                 const Icon(Icons.category),
//                                 const SizedBox(width: 8),
//                                 Text(item.category),
//                               ],
//                             ),
//                             subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.person, size: 20),
//                                       const SizedBox(width: 8),
//                                       Text('بواسطة: ${item.name}'),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.calendar_month,
//                                           size: 20),
//                                       const SizedBox(width: 8),
//                                       Text('بتاريخ: $formattedDate'),
//                                     ],
//                                   ),
//                                 ]),
//                             trailing: const Icon(Icons.arrow_forward_ios),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                   return const Text("No items found or error occurred");
//                 },
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddItemDialog,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
