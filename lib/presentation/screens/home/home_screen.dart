import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maaya/presentation/screens/home/chat_screen.dart';
import 'package:maaya/presentation/screens/home/reminders_page.dart';
import 'package:maaya/presentation/widgets/custom_glass_container.dart';
import 'dashboard_page.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final dashboardKey = GlobalKey<DashboardPageState>();

  late final _pages = [
    DashboardPage(key: dashboardKey),
    const ReminderPage(),
    const ChatScreen(),
    const Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: CustomGlassContainer(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 60,
            child: BottomNavigationBar(
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor:
                  isDark
                      ? Colors.white.withOpacity(0.5)
                      : Colors.black.withOpacity(0.5),
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/home_icon.svg',
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 0
                          ? Theme.of(context).primaryColor
                          : (isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5)),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'home'.tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/calendar_icon.svg',
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 1
                          ? Theme.of(context).primaryColor
                          : (isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5)),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'reminders'.tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/advice_icon.svg',
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 2
                          ? Theme.of(context).primaryColor
                          : (isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5)),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'advices'.tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/settings_icon.svg',
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 3
                          ? Theme.of(context).primaryColor
                          : (isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5)),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'settings'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
