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

class _DetailsPageState extends State<DetailsPage> with TickerProviderStateMixin {
  late Pet pet;
  late ConfettiController _confettiController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  bool _isAdopting = false;

  @override
  void initState() {
    super.initState();
    pet = widget.pet;

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController.forward();

    if (!pet.isAdopted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _showImageViewer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(pet.name, style: const TextStyle(color: Colors.white)),
          ),
          body: PhotoView(
            imageProvider: NetworkImage(pet.imageUrl),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
          ),
        ),
      ),
    );
  }

  Future<void> _adoptPet() async {
    if (pet.isAdopted) return;

    setState(() => _isAdopting = true);
    _pulseController.stop();

    pet.isAdopted = true;
    await widget.petRepository.updatePet(pet);

    setState(() => _isAdopting = false);
    _confettiController.play();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [Colors.green.shade50, Colors.teal.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, size: 50, color: Colors.green.shade600),
              ),
              const SizedBox(height: 20),
              Text(
                'Congratulations!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
              ),
              const SizedBox(height: 12),
              Text(
                'You\'ve successfully adopted ${pet.name}!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                'Thank you for giving ${pet.name} a loving home! 🏠❤️',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                  child: const Text('Amazing!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adopted = pet.isAdopted;

    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Stack(
          children: [
        CustomScrollView(
        slivers: [
        SliverAppBar(
        expandedHeight: 350.0,
          floating: false,
          pinned: true,
          backgroundColor: adopted ? Colors.grey.shade600 : Colors.blue.shade600,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
              child: Text(pet.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: _showImageViewer,
                  child: Hero(
                    tag: pet.id,
                    child: Image.network(
                      pet.imageUrl,
                      fit: BoxFit.cover,
                      color: adopted ? Colors.grey : null,
                      colorBlendMode: adopted ? BlendMode.saturation : null,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: Icon(Icons.pets, size: 100, color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                if (adopted)
                  Positioned(
                    top: 100,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 10, offset: Offset(2, 4))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.home, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text('Adopted', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(_slideAnimation),
                child: FadeTransition(
                    opacity: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pet info cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoCard(
                                    Icons.pets,
                                    'Type',
                                    pet.type,
                                    Colors.blue.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildInfoCard(
                                    Icons.cake,
                                    'Age',
                                    '${pet.age} years',
                                    Colors.orange.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildInfoCard(
                                    Icons.attach_money,
                                    'Price',
                                    '\$${pet.price.toStringAsFixed(2)}',
                                    adopted ? Colors.grey.shade600 : Colors.green.shade600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Description section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.purple.shade600,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'About ${pet.name}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Meet ${pet.name}, a wonderful ${pet.type.toLowerCase()} who is ${pet.age} years old and looking for a loving home. This adorable companion would make a perfect addition to any family!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Action buttons
                            Column(
                              children: [
                                // Adopt button
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: adopted ? 1.0 : _pulseAnimation.value,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: adopted || _isAdopting ? null : _adoptPet,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: adopted
                                                ? Colors.grey.shade400
                                                : Colors.blue.shade600,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            elevation: adopted ? 2 : 8,
                                            shadowColor: adopted
                                                ? Colors.grey.withOpacity(0.3)
                                                : Colors.blue.withOpacity(0.4),
                                          ),
                                          child: _isAdopting
                                              ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Processing...',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                              : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                adopted ? Icons.check_circle : Icons.home,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                adopted
                                                    ? 'Already Adopted'
                                                    : 'Adopt ${pet.name}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Favorite button
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      setState(() {
                                        pet.isFavorite = !pet.isFavorite;
                                      });
                                      await widget.petRepository.updatePet(pet);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: pet.isFavorite
                                          ? Colors.red.shade600
                                          : Colors.grey.shade600,
                                      side: BorderSide(
                                        color: pet.isFavorite
                                            ? Colors.red.shade300
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      backgroundColor: pet.isFavorite
                                          ? Colors.red.shade50
                                          : Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          pet.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 24,
                                          color: pet.isFavorite
                                              ? Colors.red
                                              : Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          pet.isFavorite
                                              ? 'Remove from Favorites'
                                              : 'Add to Favorites',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                    ),
                ),
            ),
        ),
        ],
        ),
            // Confetti overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
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
                      Colors.yellow,
                      Colors.red,
                    ],
                    numberOfParticles: 30,
                    gravity: 0.2,
                    emissionFrequency: 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}