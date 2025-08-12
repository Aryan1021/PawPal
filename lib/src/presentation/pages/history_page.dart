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

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  List<Pet> _adoptedPets = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late AnimationController _headerAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadAdoptedPets();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadAdoptedPets() async {
    final pets = await widget.petRepository.getAdoptedPets();
    setState(() {
      _adoptedPets = pets;
      _isLoading = false;
    });
    _headerAnimationController.forward();
    _animationController.forward();
  }

  Widget _buildPetCard(Pet pet, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Enhanced theme colors
    final cardColor = isDark ? theme.cardColor : Colors.white;
    final shadowColor = isDark ? Colors.black54 : Colors.blue.withOpacity(0.15);
    final borderColor = isDark ? Colors.blue.shade700 : Colors.blue.shade200;

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
              begin: const Offset(-0.3, 0),
              end: Offset.zero,
            ).animate(animation),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: isDark ? 8 : 15,
                shadowColor: shadowColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: cardColor,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                        theme.cardColor,
                        theme.cardColor.withOpacity(0.95),
                        theme.cardColor.withOpacity(0.9)
                      ]
                          : [
                        Colors.blue.shade50,
                        Colors.white,
                        Colors.cyan.shade50,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: borderColor,
                      width: isDark ? 1 : 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background decoration
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.blue.withOpacity(0.08)
                                : Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        leading: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor,
                                    blurRadius: 12,
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
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey.shade700
                                            : Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        Icons.pets,
                                        size: 35,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.blue.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    pet.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: theme.textTheme.titleLarge?.color,
                                      letterSpacing: 0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.green.shade800
                                        : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: isDark
                                            ? Colors.green.shade600
                                            : Colors.green.shade300
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.home,
                                        size: 12,
                                        color: isDark
                                            ? Colors.green.shade300
                                            : Colors.green.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Adopted',
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.green.shade300
                                              : Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.blue.shade800
                                          : Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isDark
                                              ? Colors.blue.shade600
                                              : Colors.blue.shade200
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.pets,
                                          size: 14,
                                          color: isDark
                                              ? Colors.blue.shade300
                                              : Colors.blue.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          pet.type,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.blue.shade300
                                                : Colors.blue.shade700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.orange.shade800
                                          : Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isDark
                                              ? Colors.orange.shade600
                                              : Colors.orange.shade200
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.cake,
                                          size: 14,
                                          color: isDark
                                              ? Colors.orange.shade300
                                              : Colors.orange.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${pet.age} yrs',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.orange.shade300
                                                : Colors.orange.shade700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isDark
                                              ? [Colors.purple.shade800, Colors.blue.shade800]
                                              : [Colors.purple.shade100, Colors.blue.shade100],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: isDark
                                                ? Colors.purple.shade600
                                                : Colors.purple.shade200
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.attach_money,
                                            size: 16,
                                            color: isDark
                                                ? Colors.purple.shade300
                                                : Colors.purple.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              '\$${pet.price.toStringAsFixed(2)} - Thank you!',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.purple.shade300
                                                    : Colors.purple.shade700,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: SizedBox(
                          width: 50,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.blue.shade800
                                  : Colors.blue.shade100,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isDark
                                      ? Colors.blue.shade600
                                      : Colors.blue.shade300
                              ),
                            ),
                            child: Icon(
                              Icons.visibility,
                              size: 18,
                              color: isDark
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade600,
                            ),
                          ),
                        ),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _headerAnimationController,
            curve: Curves.easeOutBack,
          )),
          child: FadeTransition(
            opacity: _headerAnimationController,
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                    Colors.blue.shade800,
                    Colors.cyan.shade700,
                    Colors.blue.shade900,
                  ]
                      : [
                    Colors.blue.shade400,
                    Colors.cyan.shade300,
                    Colors.blue.shade500,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black54
                        : Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
                border: isDark ? Border.all(
                  color: Colors.blue.shade600.withOpacity(0.5),
                  width: 1,
                ) : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adoption History',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_adoptedPets.length} pet${_adoptedPets.length != 1 ? 's' : ''} found loving homes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_adoptedPets.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
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
                ? [
              theme.scaffoldBackgroundColor,
              Colors.grey.shade900,
              Colors.grey.shade800,
            ]
                : [
              Colors.blue.shade50,
              Colors.cyan.shade50,
              Colors.white,
            ],
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
                      color: isDark
                          ? Colors.black54
                          : Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? Colors.blue.shade300 : Colors.blue.shade400
                  ),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Loading adoption history...',
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

    if (_adoptedPets.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
              theme.scaffoldBackgroundColor,
              Colors.grey.shade900,
              Colors.grey.shade800,
            ]
                : [
              Colors.blue.shade50,
              Colors.cyan.shade50,
              Colors.white,
            ],
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
                      color: isDark
                          ? Colors.black54
                          : Colors.blue.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.history,
                  size: 80,
                  color: isDark ? Colors.blue.shade400 : Colors.blue.shade300,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'No Adoptions Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'When you adopt pets, they\'ll appear here\nas part of your adoption journey.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.blue.shade700, Colors.cyan.shade700]
                        : [Colors.blue.shade400, Colors.cyan.shade400],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
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
                      'Start Adopting',
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
              ? [
            theme.scaffoldBackgroundColor,
            Colors.grey.shade900,
            Colors.grey.shade800,
          ]
              : [
            Colors.blue.shade50,
            Colors.cyan.shade50,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _adoptedPets.length,
              itemBuilder: (context, index) {
                return _buildPetCard(_adoptedPets[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}