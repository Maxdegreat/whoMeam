import 'package:http/http.dart' as http;
import 'dart:convert';

class MusenetRepository {
  Future<String> generateMusic(String prompt) async {
    // Specify the parameters for the music to be generated
    Map<String, dynamic> body = {
      'model': 'MuseNet',
      'prompt': prompt,
      'temperature': 0.5,
    };

    String apiPath = 'https://api.openai.com/v1/engines/davinci/completions';
    // Send a post request to the OpenAI API
    http.Response response = await http.post( Uri.parse(apiPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_API_KEY',
      },
      body: jsonEncode(body),
    );

    // Parse the JSON response
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Return the generated music as a string
    return jsonResponse['choices'][0]['text'];
  }
}
