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
    // Optionally sort by some adoption time if you save timestamps (currently not saved)
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
            errorBuilder: (_, __, ___) => Icon(Icons.pets),
          ),
        ),
        title: Text(pet.name),
        subtitle:
        Text('${pet.type} • ${pet.age} yrs • \$${pet.price.toStringAsFixed(2)}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  DetailsPage(pet: pet, petRepository: widget.petRepository),
            ),
          ).then((_) => _loadAdoptedPets());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adoption History')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _adoptedPets.isEmpty
          ? Center(child: Text('No adopted pets yet'))
          : ListView.builder(
        itemCount: _adoptedPets.length,
        itemBuilder: (context, index) {
          return _buildPetCard(_adoptedPets[index]);
        },
      ),
    );
  }
}
