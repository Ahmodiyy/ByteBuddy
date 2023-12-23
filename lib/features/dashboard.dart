import 'package:bytebuddy/features/chat/presentation/view/chat.dart';
import 'package:bytebuddy/features/settings/presentation/view/settings.dart';
import 'package:bytebuddy/features/topup/presentation/view/home.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<Dashboard> {
  final List<Widget> _pages = <Widget>[
    const Home(),
    const Chat(),
    const Settings(),
  ];

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
        selectedItemColor: Pallete.greenColor,
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
