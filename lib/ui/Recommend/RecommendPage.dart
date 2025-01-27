import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/child_model.dart';

class Recommendpage extends StatefulWidget {
  const Recommendpage({super.key});

  @override
  State<Recommendpage> createState() => _RecommendpageState();
}

class _RecommendpageState extends State<Recommendpage> {
  static const String _apiUrl = 'https://api.cohere.ai/v1/generate';
  static const String _apiKey = '7DNoJE0QGQI0roKdN4shT9JW0SU7FNUldPcYyr0V';

  bool _isLoading = true;
  Map<String, dynamic>? _recommendations;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      setState(() => _isLoading = true);

      print('=== DEBUG: Sending request to Cohere ===');
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          'model': 'command-r-plus-08-2024',
          'prompt':
              '''Pilih secara acak dari kategori makanan berikut untuk setiap waktu makan (jangan gunakan makanan yang sama dengan contoh):

KATEGORI SARAPAN:
- Bubur/Sereal/Oatmeal
- Roti dan Telur
- Pancake/Waffle Sehat
- Sandwich
- Smoothie Bowl
- Nasi Goreng Sehat

KATEGORI MAKAN SIANG:
- Nasi dengan Protein (Ayam/Ikan/Daging)
- Mie Sehat/Bihun
- Salad dengan Protein
- Sup/Soto
- Bowl (Quinoa/Brown Rice)
- Wrap/Sandwich

KATEGORI MAKAN MALAM:
- Protein Panggang/Kukus
- Sayur-sayuran dengan Tahu/Tempe
- Sup/Cream Soup
- Pasta Sehat
- Ikan bakar/kukus
- Bowl (Quinoa/Brown Rice)

Berikan rekomendasi menu makanan sehat dalam format JSON persis seperti ini:
{
  "breakfast": {
    "name": "XXX",
    "ingredients": ["XXX gram ", "XXX gram"],
    "healthBenefits": "XXXXXXXXXXXXXXXXXXX",
    "nutritionFacts": ["Kalori: XXX kcal", "Protein: XX gram", "Karbohidrat: XX gram", "Lemak: XX gram", "Serat: XX gram"]
  },
  "lunch": {
    "name": "XXX",
    "ingredients": ["XXX gram ", "XXX gram"],
    "healthBenefits": "XXXXXXXXXXXXXXXXXXX",
    "nutritionFacts": ["Kalori: XXX kcal", "Protein: XX gram", "Karbohidrat: XX gram", "Lemak: XX gram", "Serat: XX gram"]
  },
  "dinner": {
    "name": "XXX",
    "ingredients": ["XXX gram ", "XXX gram"],
    "healthBenefits": "XXXXXXXXXXXXXXXXXXX",
    "nutritionFacts": ["Kalori: XXX kcal", "Protein: XX gram", "Karbohidrat: XX gram", "Lemak: XX gram", "Serat: XX gram"]
  }
}''',
          'max_tokens': 1000,
          'temperature': 0.9,
          'return_likelihoods': 'NONE',
        }),
      );

      print('=== DEBUG: Response received ===');
      print('Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('=== DEBUG: Parsed response ===');
        print(jsonEncode(jsonResponse));

        if (jsonResponse.containsKey('generations')) {
          final generatedText =
              jsonResponse['generations'][0]['text'] as String;
          print('=== DEBUG: Generated text ===');
          print(generatedText);

          // Clean up the response text
          var cleanText = generatedText.trim();

          // Extract only the JSON part
          final startIndex = cleanText.indexOf('{');
          final endIndex = cleanText.lastIndexOf('}') + 1;
          if (startIndex >= 0 && endIndex > startIndex) {
            cleanText = cleanText.substring(startIndex, endIndex);
          }

          print('=== DEBUG: Cleaned text ===');
          print(cleanText);

          try {
            final parsedRecommendations = jsonDecode(cleanText);
            print('=== DEBUG: Parsed recommendations ===');
            print(jsonEncode(parsedRecommendations));

            if (parsedRecommendations is Map<String, dynamic> &&
                parsedRecommendations.containsKey('breakfast') &&
                parsedRecommendations.containsKey('lunch') &&
                parsedRecommendations.containsKey('dinner')) {
              print('=== DEBUG: Valid recommendations found ===');
              setState(() {
                _recommendations = parsedRecommendations;
                _isLoading = false;
              });
              return;
            } else {
              print('=== DEBUG: Invalid recommendations structure ===');
              throw Exception('Format rekomendasi tidak sesuai');
            }
          } catch (e) {
            print('=== DEBUG: JSON parsing error ===');
            print(e);
            throw Exception('Gagal mengurai JSON: $e');
          }
        } else {
          print('=== DEBUG: No generations in response ===');
          throw Exception('Tidak ada hasil generasi dari Cohere');
        }
      } else {
        print('=== DEBUG: Non-200 response ===');
        print('Status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
            'Gagal mendapatkan rekomendasi (${response.statusCode})');
      }
    } catch (e) {
      print('=== DEBUG: Error caught ===');
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Coba Lagi',
            onPressed: _loadRecommendations,
          ),
        ),
      );

      // Set default recommendations
      setState(() {
        _recommendations = {
          "breakfast": {
            "name": "Bubur Ayam",
            "ingredients": [
              "100 gram beras",
              "50 gram daging ayam",
              "1 butir telur",
              "Sayuran sesuai selera"
            ],
            "healthBenefits":
                "Memberikan energi dan protein untuk memulai hari",
            "nutritionFacts": [
              "Kalori: 300 kcal",
              "Protein: 15 gram",
              "Karbohidrat: 45 gram"
            ]
          },
          "lunch": {
            "name": "Nasi Ikan Kukus",
            "ingredients": [
              "150 gram nasi",
              "100 gram ikan",
              "Sayuran sesuai selera"
            ],
            "healthBenefits": "Kaya omega-3 dan protein untuk pertumbuhan",
            "nutritionFacts": [
              "Kalori: 400 kcal",
              "Protein: 20 gram",
              "Karbohidrat: 50 gram"
            ]
          },
          "dinner": {
            "name": "Sup Sayur Tahu",
            "ingredients": [
              "100 gram sayuran campur",
              "50 gram tahu",
              "Bumbu sup secukupnya"
            ],
            "healthBenefits": "Mudah dicerna dan kaya nutrisi",
            "nutritionFacts": [
              "Kalori: 250 kcal",
              "Protein: 10 gram",
              "Karbohidrat: 30 gram"
            ]
          }
        };
        _isLoading = false;
      });
    }
  }

  Widget _buildMealCard(
      String mealType, Map<String, dynamic>? mealData, int calories) {
    if (mealData == null) {
      return const Center(child: Text('Memuat rekomendasi...'));
    }

    // Extract calories from nutritionFacts
    String caloriesText = '';
    if (mealData['nutritionFacts'] != null) {
      final nutritionFacts = mealData['nutritionFacts'] as List<dynamic>;
      for (final fact in nutritionFacts) {
        if (fact.toString().toLowerCase().contains('kalori')) {
          caloriesText = fact.toString().replaceAll(RegExp(r'[^0-9]'), '');
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              mealType,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.local_fire_department),
            Text(
              ' ${caloriesText.isNotEmpty ? '$caloriesText kcal' : '$calories kcal'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealData['name'] ?? 'Memuat...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bahan-bahan:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...(mealData['ingredients'] as List<dynamic>? ?? [])
                    .map<Widget>((ingredient) => Text('• $ingredient'))
                    .toList(),
                const SizedBox(height: 16),
                const Text(
                  'Manfaat kesehatan:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(mealData['healthBenefits'] ?? 'Memuat...'),
                const SizedBox(height: 16),
                const Text(
                  'Informasi Gizi:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...(mealData['nutritionFacts'] as List<dynamic>? ?? [])
                    .map<Widget>((fact) => Text('• $fact'))
                    .toList(),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add to meal plan functionality
                    },
                    child: const Text('TAMBAH KE PLAN'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Rekomendasi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadRecommendations,
              tooltip: 'Muat ulang rekomendasi',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_recommendations != null) ...[
                      _buildMealCard(
                          'Sarapan', _recommendations!['breakfast'], 450),
                      const SizedBox(height: 16),
                      _buildMealCard(
                          'Makan Siang', _recommendations!['lunch'], 600),
                      const SizedBox(height: 16),
                      _buildMealCard(
                          'Makan Malam', _recommendations!['dinner'], 500),
                    ] else
                      const Center(
                        child: Text(
                          'Tidak ada rekomendasi tersedia.\nTarik ke bawah untuk memuat ulang.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
