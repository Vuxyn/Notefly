import 'package:flutter/material.dart';
import 'package:notefly/core/theme.dart';
import 'package:notefly/ui/screens/notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'WELCOME TO NOTEFLY',
      'body': 'Your ultra-fast floating notes companion. Always there when you need it.',
      'icon': 'flight_takeoff',
      'color': '0xFF2DD4BF', // Soft Teal
    },
    {
      'title': 'HOW IT WORKS',
      'body': 'A simple bubble floats on your screen. Tap it anytime to write a note without leaving your current app.',
      'icon': 'bubble_chart',
      'color': '0xFFFCD34D', // Yellow
    },
    {
      'title': 'PERMISSION NEEDED',
      'body': 'To float over other apps, Notefly needs the "Display over other apps" permission.',
      'icon': 'security',
      'color': '0xFFF87171', // Red
    },
  ];

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', false);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NotesScreen()),
      );
    }
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'flight_takeoff':
        return Icons.flight_takeoff_rounded;
      case 'bubble_chart':
        return Icons.bubble_chart_rounded;
      case 'security':
        return Icons.security_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  final bgColor = Color(int.parse(page['color']!));

                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border.all(color: Colors.black, width: 4),
                            boxShadow: AppTheme.brutalShadow,
                          ),
                          child: Center(
                            child: Icon(
                              _getIcon(page['icon']!),
                              size: 100,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page['title']!,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['body']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppTheme.primary : Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
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
}
