import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<Home> {
  static const List<Widget> _pages = <Widget>[];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Pallete.whiteColor,
        selectedItemColor: Pallete.whiteColor,
        currentIndex: _selectedIndex,
        elevation: 3,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.login_outlined,
            ),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt_sharp),
            label: 'Sensor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_gmailerrorred_outlined),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}
