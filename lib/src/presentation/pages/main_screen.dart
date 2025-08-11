import 'package:flutter/material.dart';
import '../../data/repositories/pet_repository.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'history_page.dart';

class MainScreen extends StatefulWidget {
  final PetRepository petRepository;

  const MainScreen({Key? key, required this.petRepository}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  final List<String> _titles = [
    'PawPal - Adopt a Pet',
    'Your Favorite Pets',
    'Adoption History'
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(petRepository: widget.petRepository),
      FavoritesPage(petRepository: widget.petRepository),
      HistoryPage(petRepository: widget.petRepository),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
