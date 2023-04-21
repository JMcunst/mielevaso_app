import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailService {
  static const String _apiUrl = 'https://api.mailgun.net/v3/<YOUR_DOMAIN_NAME>/messages';
  static const String _apiKey = '<YOUR_API_KEY>';

  static Future<bool> sendMail(String recipient, String subject, String body) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('api:$_apiKey')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'from': 'My App no.reply.ezcominc@gmail.com',
        'to': recipient,
        'subject': subject,
        'text': body,
      },
    );

    return response.statusCode == 200;
  }
}