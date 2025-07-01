import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:maaya/core/services/local_db_service.dart';
import 'package:get/get.dart';
import 'package:maaya/presentation/widgets/add_water_dialog.dart';
import 'package:maaya/presentation/widgets/week_water_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  double _todayTotal = 0;
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  List<double> _weeklyData = List.filled(7, 0);

  Future<void> refreshData() async {
    await Future.wait([loadToday(), loadWeeklyData()]);
  }

  String formatWaterAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} ${'unit_l'.tr}';
    } else {
      return '${amount.toStringAsFixed(1)} ${'unit_ml'.tr}';
    }
  }

  double _calculateWaterWaveHeight(double amountMl) {
    const double minHeight = 41;
    const double maxHeight = 200;
    const double maxAmount = 5000;

    if (amountMl >= maxAmount) return maxHeight;

    final ratio = amountMl / maxAmount;
    return minHeight + (maxHeight - minHeight) * ratio;
  }

  void _startAccurateMinuteUpdater() {
    final now = DateTime.now();
    final msUntilNextMinute = (60 - now.second) * 1000 - now.millisecond;

    Future.delayed(Duration(milliseconds: msUntilNextMinute), () {
      if (!mounted) return;

      setState(() => _currentTime = DateTime.now());

      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (!mounted) return;
        setState(() => _currentTime = DateTime.now());
      });
    });
  }

  Future<void> loadWeeklyData() async {
    final weeklyTotals = await LocalDBService.getWeeklyTotals();
    if (!mounted) return;
    setState(() {
      _weeklyData = weeklyTotals;
    });
  }

  Future<void> loadToday() async {
    try {
      final total = await LocalDBService.getTodayTotal();
      if (!mounted) return;
      setState(() => _todayTotal = total);
    } catch (e) {
      debugPrint('Error loading today total: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadToday();
    loadWeeklyData();
    _startAccurateMinuteUpdater();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = DateFormat('HH:mm').format(_currentTime);
    final textDirection = Directionality.of(context);

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'actual_trucking'.tr,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: screenSize.width,
                      height: 180,
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? const Color.fromARGB(
                                  255,
                                  38,
                                  38,
                                  38,
                                ).withOpacity(0.8)
                                : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDark
                                    ? Colors.black.withOpacity(0.7)
                                    : Colors.grey.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -40,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(25),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOut,
                                width: screenSize.width,
                                height: _calculateWaterWaveHeight(_todayTotal),
                                child: SvgPicture.asset(
                                  'assets/images/water_waves_img.svg',
                                  fit: BoxFit.fitWidth,
                                  width: screenSize.width,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (180 - 120) / 2,
                            left:
                                textDirection == TextDirection.rtl ? 10 : null,
                            right:
                                textDirection == TextDirection.ltr ? 10 : null,
                            child: SvgPicture.asset(
                              "assets/images/water_drop_img.svg",
                              width: 80,
                              height: 130,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'you_have_drinked'.trParams({
                                    'value': formatWaterAmount(_todayTotal),
                                  }),
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isDark
                                            ? Colors.white70
                                            : const Color(0xFF1F1F1F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                WeeklyWaterChart(weeklyData: _weeklyData, isDark: isDark),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FloatingActionButton.extended(
            onPressed: () async {
              final added = await showAddWaterDialog(context);
              if (added && mounted) {
                refreshData();
              }
            },
            icon: const Icon(Icons.water_drop_outlined, color: Colors.white),
            label: Text(
              'log_water_amount'.tr,
              style: const TextStyle(
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
          ),
        ),
        floatingActionButtonLocation:
            textDirection == TextDirection.rtl
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
