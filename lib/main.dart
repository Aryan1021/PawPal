import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/data/models/pet_model.dart';
import 'src/data/datasources/pet_local_datasource.dart';
import 'src/data/repositories/pet_repository.dart';
import 'src/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PetAdapter());

  final petBox = await Hive.openBox<Pet>('pets');

  final localDataSource = PetLocalDataSourceImpl();
  final petRepository = PetRepositoryImpl(localDataSource: localDataSource, petBox: petBox);

  runApp(PawPalApp(petRepository: petRepository));
}

class PawPalApp extends StatelessWidget {
  final PetRepository petRepository;

  const PawPalApp({Key? key, required this.petRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawPal',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      themeMode: ThemeMode.system,
      home: HomePage(petRepository: petRepository),
    );
  }
}
