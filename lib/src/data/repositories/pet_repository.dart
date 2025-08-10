import '../datasources/pet_local_datasource.dart';
import '../models/pet_model.dart';
import 'package:hive/hive.dart';

abstract class PetRepository {
  Future<List<Pet>> getAllPets();

  Future<void> updatePet(Pet pet);

  Future<List<Pet>> getAdoptedPets();

  Future<List<Pet>> getFavoritePets();
}

class PetRepositoryImpl implements PetRepository {
  final PetLocalDataSource localDataSource;
  final Box<Pet> petBox;

  PetRepositoryImpl({
    required this.localDataSource,
    required this.petBox,
  });

  @override
  Future<List<Pet>> getAllPets() async {
    // If Hive box is empty, load from local JSON and cache in Hive
    if (petBox.isEmpty) {
      final pets = await localDataSource.fetchPets();
      await petBox.addAll(pets);
      return pets;
    } else {
      return petBox.values.toList();
    }
  }

  @override
  Future<void> updatePet(Pet pet) async {
    // Update pet in Hive box by key (assuming id == key)
    final existingKey = petBox.keys.firstWhere(
          (key) => petBox.get(key)?.id == pet.id,
      orElse: () => null,
    );
    if (existingKey != null) {
      await petBox.put(existingKey, pet);
    } else {
      await petBox.add(pet);
    }
  }

  @override
  Future<List<Pet>> getAdoptedPets() async {
    return petBox.values.where((pet) => pet.isAdopted).toList();
  }

  @override
  Future<List<Pet>> getFavoritePets() async {
    return petBox.values.where((pet) => pet.isFavorite).toList();
  }
}
