import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  Future<String> getExpandedUrl({required String shortUrl}) async {
    if (!shortUrl.startsWith("http://") && !shortUrl.startsWith("https://")) {
      shortUrl = "https://$shortUrl"; // Add protocol if missing
    }

    if (isValidUrl(url: shortUrl)) {
      try {
        final client = http.Client();
        http.Request request = http.Request("HEAD", Uri.parse(shortUrl));
        request.followRedirects = false;
        http.StreamedResponse response = await client.send(request);

        while (response.statusCode >= 300 &&
            response.statusCode < 400 &&
            response.headers.containsKey('location')) {
          final interimUri = Uri.parse(response.headers['location']!);
          request = http.Request("HEAD", interimUri)..followRedirects = false;
          response = await client.send(request);
        }

        if (response.statusCode >= 400) {
          return "Wrong URL";
        }

        return response.request?.url.toString() ?? "Wrong URL";
      } catch (e) {
        return "Wrong URL";
      }
    } else {
      return "Wrong URL";
    }
  }

  bool isValidUrl({required String url}) {
    final urlRegEx = RegExp(
      r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+([\/\w.-]*)*\/?$',
      caseSensitive: false,
    );

    return urlRegEx.hasMatch(url);
  }

  static String apiKey =
      "AIzaSyD8TmnY9_TchMe8yWIEuCAUjlFPwtetuJs"; // Replace with your API key

  Future<Map<String, dynamic>> checkUrlSafety(String url) async {
    final String apiUrl =
        "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$apiKey";

    final Map<String, dynamic> requestBody = {
      "client": {"clientId": "yourappname", "clientVersion": "1.0.0"},
      "threatInfo": {
        "threatTypes": ["MALWARE", "SOCIAL_ENGINEERING"],
        "platformTypes": ["ANY_PLATFORM"],
        "threatEntryTypes": ["URL"],
        "threatEntries": [
          {"url": url}
        ]
      }
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response Data: ${jsonEncode(responseBody)}"); // Print response

        return responseBody; // Return full response body
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        return {"error": "Failed to fetch data"};
      }
    } catch (e) {
      print("Error: $e");
      return {"error": e.toString()};
    }
  }
}
