import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/chat/presentation/view/chat.dart';
import 'package:bytebuddy/features/settings/presentation/view/settings.dart';
import 'package:bytebuddy/features/topup/presentation/view/home.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Destination {
  const Destination(this.icon, this.label);
  final Widget icon;
  final String label;
}

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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      bool isMobile = constraints.isMobile;
      return SafeArea(
        child: Scaffold(
          body: Row(
            children: [
              if (!isMobile)
                NavigationRail(
                    selectedIndex: _selectedIndex,
                    backgroundColor: Pallete.secondaryColor,
                    onDestinationSelected: _onItemTapped,
                    leading: Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                        ),
                      ],
                    ),
                    groupAlignment: -0.85,
                    destinations: [
                      NavigationRailDestination(
                        icon: SvgPicture.asset(_selectedIndex != 0
                            ? SvgConstant.homeOutlined
                            : SvgConstant.homeFilled),
                        label: AutoSizeText('Home'),
                      ),
                      NavigationRailDestination(
                        icon: SvgPicture.asset(_selectedIndex != 1
                            ? SvgConstant.chatsOutlined
                            : SvgConstant.chatsFilled),
                        label: AutoSizeText('Chat'),
                      ),
                      NavigationRailDestination(
                        icon: SvgPicture.asset(_selectedIndex != 2
                            ? SvgConstant.settingsOutlined
                            : SvgConstant.settingsFilled),
                        label: AutoSizeText('Me'),
                      ),
                    ]),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
              ),
            ],
          ),
          bottomNavigationBar: !isMobile
              ? null
              : BottomNavigationBar(
                  backgroundColor: Pallete.secondaryColor,
                  selectedItemColor: Pallete.primaryColor,
                  currentIndex: _selectedIndex,
                  elevation: 3,
                  onTap: _onItemTapped,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(_selectedIndex != 0
                          ? SvgConstant.homeOutlined
                          : SvgConstant.homeFilled),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(_selectedIndex != 1
                          ? SvgConstant.chatsOutlined
                          : SvgConstant.chatsFilled),
                      label: 'Chat',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(_selectedIndex != 2
                          ? SvgConstant.settingsOutlined
                          : SvgConstant.settingsFilled),
                      label: 'Me',
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
