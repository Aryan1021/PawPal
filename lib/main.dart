import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'src/core/theme/app_theme.dart';
import 'src/data/models/pet_model.dart';
import 'src/data/datasources/pet_local_datasource.dart';
import 'src/data/repositories/pet_repository.dart';
import 'src/presentation/pages/main_screen.dart';
import 'src/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());

  // Setup data layer
  final petBox = await Hive.openBox<Pet>('pets');
  final localDataSource = PetLocalDataSourceImpl();
  final petRepository = PetRepositoryImpl(
    localDataSource: localDataSource,
    petBox: petBox,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: PawPalApp(petRepository: petRepository),
    ),
  );
}

class PawPalApp extends StatelessWidget {
  final PetRepository petRepository;

  const PawPalApp({Key? key, required this.petRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'PawPal',
          debugShowCheckedModeBanner: false,

          // Use the enhanced themes from AppTheme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          // Add theme animation
          themeAnimationDuration: const Duration(milliseconds: 300),
          themeAnimationCurve: Curves.easeInOut,

          home: MainScreen(petRepository: petRepository),
        );
      },
    );
  }
}