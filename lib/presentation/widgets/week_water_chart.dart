import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/core/theme/app_colors.dart';

class WeeklyWaterChart extends StatefulWidget {
  final List<double> weeklyData;
  final bool isDark;

  const WeeklyWaterChart({
    super.key,
    required this.weeklyData,
    required this.isDark,
  });

  @override
  State<WeeklyWaterChart> createState() => _WeeklyWaterChartState();
}

class _WeeklyWaterChartState extends State<WeeklyWaterChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Color> barColors = [
    const Color.fromARGB(255, 77, 205, 255),
    const Color.fromARGB(255, 34, 183, 252),
    const Color.fromARGB(255, 18, 180, 255),
    const Color.fromARGB(255, 19, 138, 217),
    const Color.fromARGB(255, 6, 118, 210),
    const Color.fromARGB(255, 13, 99, 204),
    const Color.fromARGB(255, 5, 60, 199),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatVolume(double val) {
    return val >= 1000
        ? '${(val / 1000).toStringAsFixed(1)} ${'unit_l'.tr}'
        : '${val.toStringAsFixed(0)} ${'unit_ml'.tr}';
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final List<String> days = [
      'monday'.tr,
      'tuesday'.tr,
      'wednesday'.tr,
      'thursday'.tr,
      'friday'.tr,
      'saturday'.tr,
      'sunday'.tr,
    ];

    final maxVal =
        widget.weeklyData.isEmpty
            ? 0.0
            : widget.weeklyData.reduce((a, b) => a > b ? a : b);

    final textColor = widget.isDark ? Colors.white : Colors.black;

    final data = List.generate(
      7,
      (index) => {
        'day': days[index],
        'val': widget.weeklyData[index],
        'color': barColors[index % barColors.length],
      },
    );

    if (isRTL) data.reversed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'water_trucking_week'.tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(
          height: 210,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    data.map((entry) {
                      final val = entry['val'] as double;
                      final barHeight = maxVal == 0 ? 0 : (val / maxVal) * 150;
                      final animatedHeight = barHeight * _animation.value;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            formatVolume(val),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 500),
                            width: 18,
                            height: animatedHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  (entry['color'] as Color).withOpacity(0.7),
                                  (entry['color'] as Color).withOpacity(1.0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            entry['day'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
