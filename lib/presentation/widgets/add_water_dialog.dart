import 'package:flutter/material.dart';
import 'package:maaya/core/theme/app_colors.dart';
import 'package:maaya/presentation/widgets/overlay_alert.dart';
import '../../core/services/local_db_service.dart';
import 'package:get/get.dart';

Future<bool> showAddWaterDialog(BuildContext context) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final controller = TextEditingController();

  return await showDialog<bool>(
        context: context,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: StatefulBuilder(
              // this is key to controlling dialog state
              builder: (context, setState) {
                final bottomInset = MediaQuery.of(context).viewInsets.bottom;

                return AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: bottomInset + 20,
                  ),
                  curve: Curves.decelerate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'add_water_amount'.tr,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                          hintText: 'enter_amount_hint'.tr,
                          prefixIcon: const Icon(
                            Icons.local_drink,
                            color: AppColors.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.8,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.4)
                                    : Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('cancel'.tr),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(
                                context,
                              ).unfocus(); // THIS will work now

                              final amount = double.tryParse(controller.text);
                              if (amount != null && amount > 0) {
                                await LocalDBService.insertWater(amount);
                                Navigator.pop(context, true);
                              } else {
                                showOverlayAlert(
                                  context: context,
                                  message: 'invalid_amount'.tr,
                                  isError: true,
                                );
                              }
                            },
                            child: Text('add'.tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ) ??
      false;
}
