import 'package:flutter/material.dart';
import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  final PetRepository petRepository;

  const HomePage({Key? key, required this.petRepository}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pet> _allPets = [];
  List<Pet> _filteredPets = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPets();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadPets() async {
    final pets = await widget.petRepository.getAllPets();
    setState(() {
      _allPets = pets;
      _filteredPets = pets;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPets =
          _allPets.where((pet) => pet.name.toLowerCase().contains(query)).toList();
    });
  }

  Future<void> _refreshPets() async {
    await _loadPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            errorBuilder: (_, __, ___) => Icon(Icons.pets),
          ),
        ),
        title: Text(pet.name),
        subtitle:
        Text('${pet.type} • ${pet.age} yrs • \$${pet.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pet.isAdopted)
              Text('Adopted', style: TextStyle(color: Colors.red)),
            const SizedBox(width: 8),
            Icon(
              pet.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: pet.isFavorite ? Colors.red : null,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  DetailsPage(pet: pet, petRepository: widget.petRepository),
            ),
          ).then((_) => _loadPets());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PawPal - Adopt a Pet'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search pets by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPets,
              child: _filteredPets.isEmpty
                  ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [Center(child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No pets found'),
                ))],
              )
                  : ListView.builder(
                itemCount: _filteredPets.length,
                itemBuilder: (context, index) {
                  final pet = _filteredPets[index];
                  return _buildPetCard(pet);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
