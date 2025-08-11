import 'package:flutter/material.dart';

import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';
import 'details_page.dart';

class HistoryPage extends StatefulWidget {
  final PetRepository petRepository;

  const HistoryPage({Key? key, required this.petRepository}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Pet> _adoptedPets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdoptedPets();
  }

  Future<void> _loadAdoptedPets() async {
    final pets = await widget.petRepository.getAdoptedPets();
    setState(() {
      _adoptedPets = pets;
      _isLoading = false;
    });
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailsPage(
                pet: pet,
                petRepository: widget.petRepository,
              ),
            ),
          ).then((_) => _loadAdoptedPets());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_adoptedPets.isEmpty) {
      return const Center(child: Text('No adopted pets yet'));
    }

    return ListView.builder(
      itemCount: _adoptedPets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(_adoptedPets[index]);
      },
    );
  }
}
