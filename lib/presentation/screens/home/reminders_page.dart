import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maaya/core/theme/app_colors.dart';
import 'package:maaya/presentation/controllers/reminder_controller.dart';
import 'package:maaya/presentation/widgets/reminder_list_section.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final ReminderController controller = Get.put(ReminderController());
  final ScrollController _scrollController = ScrollController();

  final List<String> _days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  bool _showTopBlur = false;

  @override
  void initState() {
    super.initState();

    controller.loadReminders();
    controller.selectedTime.value = TimeOfDay.now();

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      if (offset > 10 && !_showTopBlur) {
        setState(() => _showTopBlur = true);
      } else if (offset <= 10 && _showTopBlur) {
        setState(() => _showTopBlur = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime.value,
    );
    if (picked != null) {
      controller.selectedTime.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==== INPUT CARD ====
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder:
                      (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient:
                                isDark
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFF2C2C2C),
                                        Color(0xFF1A1A1A),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                    : LinearGradient(
                                      colors: [Colors.white, Colors.grey[100]!],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
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
                                        ? Colors.black.withOpacity(0.6)
                                        : Colors.grey.withOpacity(0.3),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ==== Time Picker ====
                              Obx(
                                () => GestureDetector(
                                  onTap: () => pickTime(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? Colors.grey[900]
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color:
                                            isDark
                                                ? Colors.white.withOpacity(0.08)
                                                : Colors.black.withOpacity(
                                                  0.08,
                                                ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 20,
                                              color:
                                                  isDark
                                                      ? AppColors.gray
                                                      : AppColors.grayDark,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'reminder_time'.tr,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          controller.selectedTime.value.format(
                                            context,
                                          ),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              Text(
                                'select_days'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Obx(
                                () => Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children:
                                      _days.map((day) {
                                        final selected = controller.selectedDays
                                            .contains(day);
                                        return ChoiceChip(
                                          label: Text(day.tr),
                                          selected: selected,
                                          showCheckmark: false,
                                          onSelected: (value) {
                                            if (value) {
                                              controller.selectedDays.add(day);
                                            } else {
                                              controller.selectedDays.remove(
                                                day,
                                              );
                                            }
                                            HapticFeedback.selectionClick();
                                          },
                                          selectedColor: AppColors.primaryDark
                                              .withOpacity(0.9),
                                          backgroundColor:
                                              selected
                                                  ? null
                                                  : Theme.of(
                                                    context,
                                                  ).scaffoldBackgroundColor,
                                          labelStyle: TextStyle(
                                            color:
                                                (!selected && !isDark)
                                                    ? Colors.black
                                                    : Colors.white,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),

                              const SizedBox(height: 25),

                              GestureDetector(
                                onTapDown: (_) => HapticFeedback.lightImpact(),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    HapticFeedback.heavyImpact();
                                    await controller.addReminder(context);
                                  },
                                  icon: const Icon(
                                    Icons.water_drop_outlined,
                                    size: 20,
                                  ),
                                  label: Text(
                                    'save_reminder'.tr,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "reminders".tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => IconButton(
                        onPressed: () => controller.isGrid.toggle(),
                        icon: Icon(
                          controller.isGrid.value
                              ? Icons.view_agenda
                              : Icons.grid_view_rounded,
                        ),
                      ),
                    ),
                  ],
                ),

                ReminderListSection(controller: controller),
                const SizedBox(height: 25),
              ],
            ),
          ),

          if (_showTopBlur)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: MediaQuery.of(context).padding.top + 5,
                    color:
                        isDark
                            ? Colors.black.withOpacity(0.25)
                            : Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
