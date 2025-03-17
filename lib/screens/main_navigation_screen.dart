import 'package:flutter/material.dart';
import 'expenses_screen.dart';
import 'whiteboard_screen.dart';
import 'household_screen.dart';
import 'family_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ExpensesScreen(),
    HouseholdScreen(),
    FamilyScreen(),
    WhiteboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Households',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom),
            label: 'Families',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt),
            label: 'Whiteboard',
          ),
        ],
      ),
    );
  }
} 