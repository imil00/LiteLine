import 'package:flutter/material.dart';

class AppBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Cari',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.blue, 
      onTap: widget.onItemTapped,
    );
  }
}