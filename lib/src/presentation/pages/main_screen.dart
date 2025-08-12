import 'package:flutter/material.dart';
import '../../data/repositories/pet_repository.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'history_page.dart';
import '../widgets/theme_toggle_action.dart';

class MainScreen extends StatefulWidget {
  final PetRepository petRepository;

  const MainScreen({Key? key, required this.petRepository}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;

  late final List<Widget> _pages;

  final List<Map<String, dynamic>> _navigationItems = [
    {
      'title': 'PawPal - Adopt a Pet',
      'icon': Icons.pets,
      'label': 'Home',
      'lightGradient': [Color(0xFF667eea), Color(0xFF764ba2)],
      'darkGradient': [Color(0xFF4a90e2), Color(0xFF7b68ee)],
    },
    {
      'title': 'Your Favorite Pets',
      'icon': Icons.favorite,
      'label': 'Favorites',
      'lightGradient': [Color(0xFFf093fb), Color(0xFFf5576c)],
      'darkGradient': [Color(0xFFff6b9d), Color(0xFFc44569)],
    },
    {
      'title': 'Adoption History',
      'icon': Icons.history,
      'label': 'History',
      'lightGradient': [Color(0xFF4facfe), Color(0xFF00f2fe)],
      'darkGradient': [Color(0xFF2196f3), Color(0xFF21cbf3)],
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pages = [
      HomePage(petRepository: widget.petRepository),
      FavoritesPage(petRepository: widget.petRepository),
      HistoryPage(petRepository: widget.petRepository),
    ];

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _navigationItems[_currentIndex];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Select appropriate gradient based on theme
    final gradientColors = isDark
        ? currentItem['darkGradient']
        : currentItem['lightGradient'];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black54 : Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Row(
                key: ValueKey(_currentIndex),
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      currentItem['icon'],
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      currentItem['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            actions: const [
              ThemeToggleAction(),
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navigationItems.length, (index) {
                final item = _navigationItems[index];
                final isSelected = _currentIndex == index;
                final itemGradient = isDark
                    ? item['darkGradient']
                    : item['lightGradient'];

                return GestureDetector(
                  onTap: () => _onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                        colors: itemGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: itemGradient[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item['icon'],
                          color: isSelected
                              ? Colors.white
                              : theme.bottomNavigationBarTheme.unselectedItemColor,
                          size: 24,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                            item['label'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}