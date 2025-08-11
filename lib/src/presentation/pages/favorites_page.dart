import 'package:flutter/material.dart';

import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';
import 'details_page.dart';

class FavoritesPage extends StatefulWidget {
  final PetRepository petRepository;

  const FavoritesPage({Key? key, required this.petRepository}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Pet> _favoritePets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoritePets();
  }

  Future<void> _loadFavoritePets() async {
    final pets = await widget.petRepository.getFavoritePets();
    setState(() {
      _favoritePets = pets;
      _isLoading = false;
    });
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      color: pet.isAdopted ? Colors.grey.shade300 : null,
      child: ListTile(
        leading: Hero(
          tag: pet.id,
          child: Image.network(
            pet.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.pets),
          ),
        ),
        title: Text(pet.name),
        subtitle: Text('${pet.type} • ${pet.age} yrs • \$${pet.price.toStringAsFixed(2)}'),
        trailing: pet.isAdopted
            ? const Text('Adopted', style: TextStyle(color: Colors.red))
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailsPage(
                pet: pet,
                petRepository: widget.petRepository,
              ),
            ),
          ).then((_) => _loadFavoritePets());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favoritePets.isEmpty) {
      return const Center(child: Text('No favorite pets found'));
    }

    return ListView.builder(
      itemCount: _favoritePets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(_favoritePets[index]);
      },
    );
  }
}
