import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_scanner_proj/forages.dart';
import 'package:phone_scanner_proj/image_classifier.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImageClassifier _imageClassifier = ImageClassifier();
  Map<String, double>? _results;
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    setState(() => _isLoading = true);
    await _imageClassifier.loadModelAndLabels(
      'assets/model.tflite',
      'assets/labels.txt',
    );
    setState(() => _isLoading = false);
  }

  Future<void> _classifyImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _isLoading = true;
      _image = File(pickedFile.path);
      _results = null;
    });

    final results = await _imageClassifier.classifyImage(pickedFile.path);
    print('Classification results: $results');
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Scan a Plant',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  // Description text with improved typography

                  const SizedBox(height: 24),

                  // Image Preview Card - Modernized
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _image == null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_camera_back_rounded,
                                    size: 48,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Upload or capture an image',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.zoom_in_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons - Modern Style
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(
                                color: Colors.blue.shade400,
                                width: 1.5,
                              ),
                            ),
                            onPressed: () =>
                                _classifyImage(ImageSource.gallery),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_library_rounded,
                                  color: Colors.blue.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => _classifyImage(ImageSource.camera),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Results Section - Minimalist Design
                  // Results Section
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue.shade600,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  else if (_results == null || _results!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tips for Capturing Forage Crops',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildTipItem(Icons.grass, "For small forages:",
                              "• Zoom in close (about 1 foot distance)\n• Capture from top view\n• Focus on leaf formation"),
                          SizedBox(height: 10),
                          _buildTipItem(Icons.park, "For tree forages:",
                              "• Position camera from below\n• Focus on leaf arrangement\n• Capture the stem-leaf connection"),
                          SizedBox(height: 10),
                          _buildTipItem(
                              Icons.photo_camera,
                              "General guidelines:",
                              "• Ensure good lighting\n• Keep the leaves in focus\n• Avoid shadows on the subject"),
                        ],
                      ),
                    )
                  else if (_results != null && _results!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IDENTIFICATION RESULTS',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  letterSpacing: 1.2,
                                ),
                          ),
                          const SizedBox(height: 12),

                          // Display highest result as full-width card
                          if (_results!.isNotEmpty)
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/forage-icon.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                          Expanded(
                                            child: Text(
                                              formatName(
                                                  _results!.entries.first.key),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            '${(_results!.entries.first.value * 100).toStringAsFixed(1)}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.blue.shade800,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: _results!.entries.first.value,
                                        minHeight: 6,
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.blue.shade600,
                                        backgroundColor: Colors.blue.shade200,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                displayResult(_results!.entries.first.key),
                              ],
                            ),
                          const SizedBox(height: 12),
                          // Display remaining results in compact rows
                          if (_results!.length > 1)
                            Column(
                              children: [
                                Text(
                                  'Other possibilities:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                ..._results!.entries.skip(1).map(
                                      (e) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    formatName(e.key),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  child: Text(
                                                    '${(e.value * 100).toStringAsFixed(1)}%',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .blue.shade600,
                                                        ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            LinearProgressIndicator(
                                              value: e.value,
                                              minHeight: 2,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: Colors.blue.shade400,
                                              backgroundColor:
                                                  Colors.blue.shade100,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors
                          .blue[50], // Light blue background for attention
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue[700], size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "This model is continuously improving. Use results as a reference guide.",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Footer
                  Container(
                    height: 52, // Slightly taller for better touch targets
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black12,
                    //       blurRadius: 6,
                    //       offset: Offset(0, -2),
                    //     )
                    //   ],
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.copyright,
                                size: 14, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              "Laurente 2025",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "ForageNet",
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    Colors.blue[700], // Brand color highlight
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "v1.0.0",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontFamily: 'RobotoMono', // Monospace alternative
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                content,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget displayResult(String result) {
    print(result);

    final forage = forages.firstWhere((f) => f['name'] == result.toLowerCase());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and scientific name
          Row(
            children: [
              Expanded(
                child: Text(
                  forage['name'].toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                forage['scientific_name'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            forage['description'] as String,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Livestock suitability
          Text(
            'LIVESTOCK SUITABILITY',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Text('Legend: ',
              style: TextStyle(
                  color: Colors.grey[800], fontStyle: FontStyle.italic)),
          Row(
            children: [
              Text('Excellent',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  )),
              SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text('Good',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  )),
              SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text('Fair',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  )),
              SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text('Poor',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  )),
              SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final entry
                  in (forage['livestock_suitability'] as Map<String, dynamic>)
                      .entries)
                Chip(
                  label: Text('${entry.key}'),
                  backgroundColor: _getSuitabilityColor(entry.value),
                  labelStyle: const TextStyle(fontSize: 12),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Nutritional content
          Text(
            'NUTRITIONAL CONTENT (per dry matter)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          ...(forage['nutritional_content'] as Map<String, dynamic>)
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          formatName(entry.key.replaceAll('_', ' ')),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 16),

          // Special notes if available
          if (forage['special_notes'] != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      forage['special_notes'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

// Helper function to get color based on suitability
  Color _getSuitabilityColor(String suitability) {
    switch (suitability) {
      case 'excellent':
        return Colors.green[100]!;
      case 'good':
        return Colors.lightBlue[100]!;
      case 'fair':
        return Colors.amber[100]!;
      case 'poor':
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  String formatName(String name) {
    String formattedName = name.replaceAll('_', ' ');
    formattedName = formattedName.replaceAll('-', ' ');
    return formattedName[0].toUpperCase() +
        formattedName.substring(1).toLowerCase();
  }
}
