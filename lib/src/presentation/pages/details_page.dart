import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:photo_view/photo_view.dart';

import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';

class DetailsPage extends StatefulWidget {
  final Pet pet;
  final PetRepository petRepository;

  const DetailsPage({
    Key? key,
    required this.pet,
    required this.petRepository,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Pet pet;
  late ConfettiController _confettiController;
  bool _isAdopting = false;

  @override
  void initState() {
    super.initState();
    pet = widget.pet;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showImageViewer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(pet.name)),
          body: PhotoView(
            imageProvider: NetworkImage(pet.imageUrl),
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _adoptPet() async {
    if (pet.isAdopted) return;

    setState(() => _isAdopting = true);

    pet.isAdopted = true;
    await widget.petRepository.updatePet(pet);

    setState(() => _isAdopting = false);

    _confettiController.play();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adopted!'),
        content: Text('You’ve now adopted ${pet.name}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adopted = pet.isAdopted;

    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showImageViewer,
                  child: Hero(
                    tag: pet.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        pet.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: adopted ? Colors.grey : null,
                        colorBlendMode:
                        adopted ? BlendMode.saturation : null,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.pets, size: 100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pet.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text('${pet.type} • ${pet.age} years old'),
                const SizedBox(height: 8),
                Text(
                  '\$${pet.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: adopted || _isAdopting ? null : _adoptPet,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: _isAdopting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    adopted ? 'Already Adopted' : 'Adopt Me',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        pet.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: pet.isFavorite ? Colors.red : null,
                        size: 32,
                      ),
                      onPressed: () async {
                        setState(() {
                          pet.isFavorite = !pet.isFavorite;
                        });
                        await widget.petRepository.updatePet(pet);
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pet.isFavorite
                          ? 'Favorited'
                          : 'Mark as Favorite',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
