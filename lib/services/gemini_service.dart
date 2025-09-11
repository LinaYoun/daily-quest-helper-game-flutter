import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class GeminiService {
  GeminiService({required this.apiKey, this.functionUrl});

  final String apiKey;
  final String? functionUrl; // Optional Cloud Function endpoint

  static const String _imageEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent';
  static const String _previewEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image-preview:generateContent';
  static const String _fallbackEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<String?> generateIconImageDataUrl(String prompt) async {
    // Prefer Cloud Function if provided
    if (functionUrl != null && functionUrl!.isNotEmpty) {
      return _callFunction(prompt: prompt);
    }
    final Map<String, dynamic> body = <String, dynamic>{
      'contents': <Map<String, dynamic>>[
        <String, dynamic>{
          'parts': <Map<String, dynamic>>[
            <String, dynamic>{'text': prompt},
          ],
        },
      ],
      'generationConfig': <String, dynamic>{
        'temperature': 0.4,
        'responseModalities': <String>['IMAGE', 'TEXT'],
      },
    };
    for (final String ep in <String>[
      _imageEndpoint,
      _previewEndpoint,
      _fallbackEndpoint,
    ]) {
      final String? res = await _postAndParse(ep, body, retries: 2);
      if (res != null) return res;
    }
    return null;
  }

  Future<String?> generateIconImageDataUrlWithReference(
    String prompt, {
    String? referenceUrl,
    String? referenceDataUrl,
    List<int>? referenceBytes,
    String referenceMimeType = 'image/png',
  }) async {
    if (functionUrl != null && functionUrl!.isNotEmpty) {
      String? dataUrl;
      if (referenceBytes != null && referenceBytes.isNotEmpty) {
        dataUrl =
            'data:$referenceMimeType;base64,${base64Encode(referenceBytes)}';
      } else if (referenceDataUrl != null && referenceDataUrl.isNotEmpty) {
        dataUrl = referenceDataUrl;
      } else if (referenceUrl != null && referenceUrl.isNotEmpty) {
        try {
          final http.Response r = await http.get(Uri.parse(referenceUrl));
          if (r.statusCode == 200) {
            dataUrl =
                'data:$referenceMimeType;base64,${base64Encode(r.bodyBytes)}';
          }
        } catch (_) {}
      }
      return _callFunction(prompt: prompt, referenceDataUrl: dataUrl);
    }
    final List<Map<String, dynamic>> parts = <Map<String, dynamic>>[];

    // Attach reference image if provided
    try {
      Map<String, dynamic>? inlineData;
      if (referenceBytes != null && referenceBytes.isNotEmpty) {
        inlineData = <String, dynamic>{
          'mimeType': referenceMimeType,
          'data': base64Encode(referenceBytes),
        };
      } else if (referenceDataUrl != null && referenceDataUrl.isNotEmpty) {
        final String base64Data = referenceDataUrl.split(',').last;
        inlineData = <String, dynamic>{
          'mimeType': referenceMimeType,
          'data': base64Data,
        };
      } else if (referenceUrl != null && referenceUrl.isNotEmpty) {
        final http.Response r = await http.get(Uri.parse(referenceUrl));
        if (r.statusCode == 200) {
          inlineData = <String, dynamic>{
            'mimeType': referenceMimeType,
            'data': base64Encode(r.bodyBytes),
          };
        }
      }
      if (inlineData != null) {
        parts.add(<String, dynamic>{'inlineData': inlineData});
      }
    } catch (e) {
      // ignore: avoid_print
      print('GeminiService reference fetch error: $e');
    }

    parts.add(<String, dynamic>{'text': prompt});

    final Map<String, dynamic> body = <String, dynamic>{
      'contents': <Map<String, dynamic>>[
        <String, dynamic>{'parts': parts},
      ],
      'generationConfig': <String, dynamic>{
        'temperature': 0.4,
        'responseModalities': <String>['IMAGE', 'TEXT'],
      },
    };
    for (final String ep in <String>[
      _imageEndpoint,
      _previewEndpoint,
      _fallbackEndpoint,
    ]) {
      final String? res = await _postAndParse(ep, body, retries: 2);
      if (res != null) return res;
    }
    return null;
  }

  Future<String?> _postAndParse(
    String endpoint,
    Map<String, dynamic> body, {
    int retries = 0,
  }) async {
    final Uri url = Uri.parse('$endpoint?key=$apiKey');
    http.Response resp;
    int attempt = 0;
    while (true) {
      try {
        resp = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
      } catch (e) {
        // ignore: avoid_print
        print('GeminiService network error: $e');
        if (attempt >= retries) return null;
        await Future<void>.delayed(Duration(milliseconds: 300 * (attempt + 1)));
        attempt++;
        continue;
      }

      if (resp.statusCode == 200) break;
      // ignore: avoid_print
      print('GeminiService error ${resp.statusCode}: ${resp.body}');
      if (attempt >= retries) return null;
      await Future<void>.delayed(Duration(milliseconds: 300 * (attempt + 1)));
      attempt++;
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;
    final List<dynamic>? candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) return null;

    final Map<String, dynamic> content =
        candidates.first['content'] as Map<String, dynamic>;
    final List<dynamic>? parts = content['parts'] as List<dynamic>?;
    if (parts == null) return null;

    for (final dynamic p in parts) {
      final Map<String, dynamic> part = p as Map<String, dynamic>;
      if (part.containsKey('inlineData')) {
        final Map<String, dynamic> inline =
            part['inlineData'] as Map<String, dynamic>;
        final String mimeType = (inline['mimeType'] as String?) ?? 'image/png';
        final String base64Data = inline['data'] as String;
        return 'data:$mimeType;base64,$base64Data';
      }
    }
    return null;
  }

  Future<String?> _callFunction({
    required String prompt,
    String? referenceDataUrl,
  }) async {
    try {
      final Uri url = Uri.parse(functionUrl!);
      final Map<String, dynamic> body = <String, dynamic>{
        'prompt': prompt,
        if (referenceDataUrl != null) 'referenceDataUrl': referenceDataUrl,
      };
      final http.Response resp = await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (resp.statusCode != 200) {
        // ignore: avoid_print
        print('Function error ${resp.statusCode}: ${resp.body}');
        return null;
      }
      final Map<String, dynamic> data =
          jsonDecode(resp.body) as Map<String, dynamic>;
      final String? dataUrl = data['dataUrl'] as String?;
      return dataUrl;
    } catch (e) {
      // ignore: avoid_print
      print('Function network error: $e');
      return null;
    }
  }
}
