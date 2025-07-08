import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maaya/core/theme/app_colors.dart';
import 'package:maaya/presentation/controllers/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool _showTopBlur = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final offset = scrollController.offset;
      if (offset > 10 && !_showTopBlur) {
        setState(() => _showTopBlur = true);
      } else if (offset <= 10 && _showTopBlur) {
        setState(() => _showTopBlur = false);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textDirection = Directionality.of(context);

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.pairs.isEmpty &&
                        !controller.isLoading.value) {
                      return Center(
                        child: Text(
                          "chat_start".tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.grayDark,
                            fontFamily: 'Nunnito',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsetsDirectional.fromSTEB(
                        12,
                        MediaQuery.of(context).padding.top + 10,
                        12,
                        12,
                      ),
                      itemCount:
                          controller.pairs.length +
                          (controller.isLoading.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= controller.pairs.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "chat_typing".tr,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 8),
                                const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final pair = controller.pairs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment:
                                  textDirection == TextDirection.rtl
                                      ? AlignmentDirectional.centerStart
                                      : AlignmentDirectional.centerEnd,
                              child: _messageBubble(
                                pair.prompt,
                                isUser: true,
                                isDark: isDark,
                                textDirection: textDirection,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment:
                                  textDirection == TextDirection.rtl
                                      ? AlignmentDirectional.centerEnd
                                      : AlignmentDirectional.centerStart,
                              child: _messageBubble(
                                pair.response,
                                isUser: false,
                                isDark: isDark,
                                textDirection: textDirection,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
            if (_showTopBlur)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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

        // Bottom Input Area
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.only(
            bottom: 10,
            right: 12,
            left: 12,
            top: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: inputController,
                  textDirection: textDirection,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: "chat_input_hint".tr,
                    hintStyle: TextStyle(
                      color:
                          isDark
                              ? AppColors.grayLight.withOpacity(0.5)
                              : AppColors.grayDark.withOpacity(0.8),
                      fontFamily: 'Roboto',
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor:
                        isDark
                            ? const Color.fromARGB(255, 27, 27, 27)
                            : AppColors.grayLight.withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            isDark
                                ? AppColors.grayLight.withOpacity(0.3)
                                : Colors.black.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            isDark
                                ? AppColors.grayLight.withOpacity(0.3)
                                : Colors.black.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (text) {
                    FocusScope.of(context).unfocus();
                    controller.sendMessage(text, context, scrollController);
                    inputController.clear();
                  },
                ),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  controller.sendMessage(
                    inputController.text,
                    context,
                    scrollController,
                  );
                  inputController.clear();
                },
                icon: Icon(
                  Icons.send_rounded,
                  color:
                      isDark
                          ? AppColors.secondary
                          : const Color.fromARGB(255, 53, 176, 57),
                  size: 28,
                ),
              ),
              GestureDetector(
                onTap: controller.resetChat,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDark
                            ? AppColors.secondary.withOpacity(0.1)
                            : const Color.fromARGB(
                              255,
                              158,
                              255,
                              200,
                            ).withOpacity(0.3),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/refresh_icon.svg',
                    width: 25,
                    height: 25,
                    color:
                        isDark
                            ? AppColors.secondary
                            : const Color.fromARGB(255, 53, 176, 57),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageBubble(
    String text, {
    required bool isUser,
    required bool isDark,
    required TextDirection textDirection,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color:
            isUser
                ? AppColors.primaryDark
                : isDark
                ? const Color.fromARGB(255, 23, 23, 23)
                : Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        textDirection: textDirection,
        style: TextStyle(
          color:
              isUser
                  ? Colors.white
                  : isDark
                  ? Colors.white
                  : Colors.black87,
          fontSize: 15,
          fontFamily: 'Nunito',
          fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
