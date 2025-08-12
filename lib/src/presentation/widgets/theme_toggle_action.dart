import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggleAction extends StatefulWidget {
  const ThemeToggleAction({Key? key}) : super(key: key);

  @override
  State<ThemeToggleAction> createState() => _ThemeToggleActionState();
}

class _ThemeToggleActionState extends State<ThemeToggleAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                onPressed: () {
                  _animationController.forward().then((_) {
                    _animationController.reset();
                  });
                  themeProvider.toggleTheme();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class SimpleThemeToggle extends StatelessWidget {
  const SimpleThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: Text(
            themeProvider.isDarkMode
                ? 'Dark theme is enabled'
                : 'Light theme is enabled',
          ),
          secondary: Icon(
            themeProvider.isDarkMode
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.setTheme(value);
          },
        );
      },
    );
  }
}