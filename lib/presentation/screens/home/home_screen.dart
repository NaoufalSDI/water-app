import 'package:flutter/material.dart';
import 'package:maaya/presentation/widgets/custom_glass_container.dart';
import 'dashboard_page.dart';
import 'package:get/get.dart';
import 'package:maaya/presentation/widgets/add_water_dialog.dart';

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
    const Placeholder(),
    const Placeholder(),
    const Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],

      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton.extended(
                onPressed: () async {
                  final added = await showAddWaterDialog(context);
                  if (added && mounted) {
                    dashboardKey.currentState?.refreshData();
                  }
                },
                icon: const Icon(
                  Icons.water_drop_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'log_water_amount'.tr,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              )
              : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: CustomGlassContainer(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 65,
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
                  icon: Icon(Icons.dashboard),
                  label: 'dashboard'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.flag),
                  label: 'objectives'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb),
                  label: 'advices'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
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
