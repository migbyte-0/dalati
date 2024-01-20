import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:dalati/features/category/data/repositories/dd.dart';

import 'core/config/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/exports.dart';
import 'features/auth/domain/usecases/update_phone_number_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/category/data/datasources/category_data_source.dart';
import 'features/category/domain/repositories/category_repository.dart';
import 'features/category/presentation/bloc/category_bloc.dart';
import 'features/item/data/datasources/item_remote_data_source.dart';
import 'features/item/data/repositories/item_repository_impl.dart';
import 'features/item/domain/usecases/add_item_usecase.dart';
import 'features/item/domain/usecases/get_items.dart';
import 'features/item/presentation/bloc/item_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize FirebaseAuth and GoogleSignIn
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Create instances of the data source and repository
    final authRemoteDataSource =
        AuthRemoteDataSource(firebaseAuth, googleSignIn);
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);
    // Create instances of the use cases
    final getCurrentUserUseCase = GetCurrentUser(authRepository);
    final signInWithGoogleUseCase = SignInWithGoogle(authRepository);
    final signOutUseCase = SignOut(authRepository);

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final CategoryDataSource categoryDataSource =
        CategoryDataSource(firestore: firestore);
    final CategoryRepository categoryRepository =
        CategoryRepositoryImpl(categoryDataSource);
    // Initialize dependencies for ItemBloc (adjust with actual implementations)
    // Example:
    final itemRemoteDataSource =
        ItemDataSource(); // Adjust with actual constructor
    final itemRepository = ItemRepositoryImpl(itemRemoteDataSource);
    final addItemUseCase = AddItem(itemRepository);
    final getItemsUseCase = GetItems(itemRepository);
    final updatePhoneNumberUseCase = UpdatePhoneNumber(authRepository);
    // Get the CategoryRepository

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(authRemoteDataSource),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => categoryRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              getCurrentUser: getCurrentUserUseCase,
              signInWithGoogle: signInWithGoogleUseCase,
              signOut: signOutUseCase,
              repository: authRepository,
              updatePhoneNumber: updatePhoneNumberUseCase,
            ),
          ),
          BlocProvider<ItemBloc>(
            create: (context) => ItemBloc(addItemUseCase, getItemsUseCase),
          ),
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
              RepositoryProvider.of<CategoryRepository>(context),
            ),
          )
        ],
        child: MaterialApp(
          title: 'ضالتي',
          theme: appTheme(), // ثيم التطبيق

          onGenerateRoute: onGenerateRoute,
          home: const AuthScreen(),
          locale: const Locale('ar', ''),

          supportedLocales: const [
            Locale('ar', ''), // دعم التطبيق للغة العربية
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        ),
      ),
    );
  }
}
