import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import '../models/pet_model.dart';

abstract class PetLocalDataSource {
  /// Loads list of pets from local JSON file
  Future<List<Pet>> fetchPets();
}

class PetLocalDataSourceImpl implements PetLocalDataSource {
  final String jsonPath;

  PetLocalDataSourceImpl({this.jsonPath = 'assets/pets.json'});

  @override
  Future<List<Pet>> fetchPets() async {
    try {
      final jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Pet.fromJson(json)).toList();
    } catch (e) {
      // You can log or rethrow error here if needed
      return [];
    }
  }
}
