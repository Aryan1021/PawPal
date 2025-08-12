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

class _FavoritesPageState extends State<FavoritesPage> with TickerProviderStateMixin {
  List<Pet> _favoritePets = [];
  bool _isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadFavoritePets();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoritePets() async {
    final pets = await widget.petRepository.getFavoritePets();
    setState(() {
      _favoritePets = pets;
      _isLoading = false;
    });
    _animationController.forward();
  }

  Widget _buildPetCard(Pet pet, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            1.0,
            curve: Curves.easeOutBack,
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(animation),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 12,
                shadowColor: isDark ? Colors.black54 : Colors.pink.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: pet.isAdopted
                    ? (isDark ? theme.cardColor.withOpacity(0.7) : Colors.grey.shade100)
                    : theme.cardColor,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: pet.isAdopted
                        ? LinearGradient(
                      colors: isDark
                          ? [Colors.grey.shade800, Colors.grey.shade700]
                          : [Colors.grey.shade200, Colors.grey.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : LinearGradient(
                      colors: isDark
                          ? [theme.cardColor, theme.cardColor.withOpacity(0.9)]
                          : [
                        Colors.pink.shade50,
                        Colors.white,
                        Colors.red.shade50,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: pet.isAdopted
                          ? (isDark ? Colors.grey.shade600 : Colors.grey.shade300)
                          : (isDark ? Colors.pink.shade800 : Colors.pink.shade100),
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    leading: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black54
                                    : Colors.pink.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(3, 6),
                              ),
                            ],
                          ),
                          child: Hero(
                            tag: pet.id,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                pet.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey.shade700
                                            : Colors.pink.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        Icons.pets,
                                        size: 35,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.pink.shade400,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      pet.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: pet.isAdopted
                            ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                            : theme.textTheme.headlineMedium?.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    subtitle: Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fixed: Use Flexible widgets to prevent overflow
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: pet.isAdopted
                                      ? (isDark ? Colors.grey.shade700 : Colors.grey.shade300)
                                      : (isDark ? Colors.pink.shade800 : Colors.pink.shade100),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pets,
                                      size: 14,
                                      color: pet.isAdopted
                                          ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                                          : (isDark ? Colors.pink.shade300 : Colors.pink.shade700),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      pet.type,
                                      style: TextStyle(
                                        color: pet.isAdopted
                                            ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                                            : (isDark ? Colors.pink.shade300 : Colors.pink.shade700),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: pet.isAdopted
                                      ? (isDark ? Colors.grey.shade700 : Colors.grey.shade300)
                                      : (isDark ? Colors.blue.shade800 : Colors.blue.shade100),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cake,
                                      size: 14,
                                      color: pet.isAdopted
                                          ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                                          : (isDark ? Colors.blue.shade300 : Colors.blue.shade700),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${pet.age} yrs',
                                      style: TextStyle(
                                        color: pet.isAdopted
                                            ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                                            : (isDark ? Colors.blue.shade300 : Colors.blue.shade700),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Fixed: Make price container flexible
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: pet.isAdopted
                                        ? (isDark ? Colors.grey.shade700 : Colors.grey.shade300)
                                        : (isDark ? Colors.green.shade800 : Colors.green.shade100),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: pet.isAdopted
                                          ? (isDark ? Colors.grey.shade500 : Colors.grey.shade400)
                                          : (isDark ? Colors.green.shade600 : Colors.green.shade300),
                                    ),
                                  ),
                                  child: Text(
                                    '\$${pet.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: pet.isAdopted
                                          ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                                          : (isDark ? Colors.green.shade300 : Colors.green.shade700),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: SizedBox(
                      width: 80,
                      // Fixed: Set specific width to prevent overflow
                      child: pet.isAdopted
                          ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.red.shade900 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: isDark ? Colors.red.shade700 : Colors.red.shade300
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Adopted',
                              style: TextStyle(
                                color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.pink.shade800 : Colors.pink.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDark ? Colors.pink.shade600 : Colors.pink.shade300
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: isDark ? Colors.pink.shade300 : Colors.pink.shade600,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailsPage(
                                pet: pet,
                                petRepository: widget.petRepository,
                              ),
                        ),
                      ).then((_) => _loadFavoritePets());
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.pink.shade50, Colors.red.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black54 : Colors.pink.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? Colors.pink.shade300 : Colors.pink.shade400
                  ),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Loading your favorites...',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_favoritePets.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.pink.shade50, Colors.red.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black54 : Colors.pink.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: isDark ? Colors.pink.shade400 : Colors.pink.shade300,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'No Favorite Pets Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.headlineMedium?.color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Start adding pets to your favorites\nby tapping the heart icon!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.pink.shade700, Colors.red.shade700]
                        : [Colors.pink.shade400, Colors.red.shade400],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Browse Pets',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.grey.shade900, Colors.grey.shade800]
              : [Colors.pink.shade50, Colors.red.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black54 : Colors.pink.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red.shade400,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Favorites',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineMedium?.color,
                        ),
                      ),
                      Text(
                        '${_favoritePets.length} pet${_favoritePets.length != 1
                            ? 's'
                            : ''} you love',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              // Fixed: Added bottom padding
              itemCount: _favoritePets.length,
              itemBuilder: (context, index) {
                return _buildPetCard(_favoritePets[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}