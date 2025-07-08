// presentation/controllers/chat_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:maaya/core/services/gemini_service.dart';
import 'package:maaya/data/models/chat_pair.dart';
import 'package:maaya/presentation/widgets/overlay_alert.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();

  RxList<ChatPair> pairs = <ChatPair>[].obs;
  RxBool isLoading = false.obs;

  void sendMessage(
    String prompt,
    BuildContext context,
    ScrollController scrollController,
  ) async {
    if (prompt.trim().isEmpty) return;

    isLoading.value = true;

    final reply = await _chatService.sendMessage(prompt);
    isLoading.value = false;

    if (reply == null || reply.startsWith("error_")) {
      showOverlayAlert(
        context: context,
        message: (reply ?? 'error_unknown').tr,
        isError: true,
      );
      return;
    }

    // === ADD CHAT MESSAGE ===
    pairs.add(ChatPair(prompt: prompt, response: reply));

    // === SCROLL TO BOTTOM ===
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void resetChat() {
    pairs.clear();
  }
}
