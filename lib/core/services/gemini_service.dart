import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/env.dart';

class ChatService {
  Future<String?> sendMessage(String prompt) async {
    final _url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${Env.geminiKey}';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      } else {
        return 'error_api';
      }
    } catch (e) {
      return 'error_connection';
    }
  }
}
