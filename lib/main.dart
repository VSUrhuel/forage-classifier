import 'package:flutter/material.dart';
import 'package:phone_scanner_proj/custom_page_route.dart';
import 'package:phone_scanner_proj/forage_card.dart';
import 'package:phone_scanner_proj/forages.dart';
import 'package:phone_scanner_proj/scan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'ForageNet',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ForagCrop {
  final String name;
  final String imagePath;
  final String description;
  final Function onClick;

  ForagCrop({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.onClick,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ForagCrop> forageCrops = [
    ForagCrop(
        name: 'Carabao Grass',
        imagePath: 'assets/carabao-grass.jpg',
        description: 'A tropical grass used for grazing and fodder.',
        onClick: () {}),
    ForagCrop(
      name: 'Centro',
      imagePath: 'assets/centro.jpg',
      description: 'A legume used for improving soil fertility.',
      onClick: () {},
    ),
    ForagCrop(
      name: 'Gliricidia',
      imagePath: 'assets/gliricidia.jpg',
      description: 'A fast-growing tree used for fodder and shade.',
      onClick: () {},
    ),
    ForagCrop(
      name: 'Leucaena',
      imagePath: 'assets/leucaena.jpg',
      description: 'A leguminous tree used for fodder and soil improvement.',
      onClick: () {},
    ),
    ForagCrop(
      name: 'Para Grass',
      imagePath: 'assets/para-grass.jpg',
      description: 'A grass species used for grazing and hay production.',
      onClick: () {},
    ),
  ];

  Future<void> _showDialog(BuildContext context, String forageName) async {
    final forage = forages.firstWhere(
      (f) => f['name'] == forageName.toLowerCase(),
      orElse: () => {},
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
                forage['name'].toString().toUpperCase().replaceAll('-', ' ')),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: SingleChildScrollView(
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
                          color: Colors.grey[800],
                          fontStyle: FontStyle.italic)),
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
                      for (final entry in (forage['livestock_suitability']
                              as Map<String, dynamic>)
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
                          const Icon(Icons.info_outline,
                              color: Colors.amber, size: 20),
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
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                CustomPageRoute(
                    page: ScanPage(), direction: AxisDirection.left));
          },
          backgroundColor: Colors.blue, // Using your theme color
          foregroundColor: Colors.white, // White icon for contrast
          elevation: 4,
          shape: CircleBorder(),

          heroTag: 'forage_classify_fab',
          child: Icon(
            Icons.camera_alt_rounded, // More modern camera icon
            size: 28,
          ), // Important if you have multiple FABs
        ),
        bottomNavigationBar: Container(
          height: 40, // Fixed height for consistency
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white, width: 1)),
            color: Colors.white, // Matches app background
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Better space distribution
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "© Laurente 2025 ForageNet",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600], // Subtle text color
                ),
              ),
              Text(
                "v1.0.0",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontFamily: 'Monospace',
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {}, // 👈 Taps Profile, switches to MenteeProfile tab
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25,
                  backgroundImage: AssetImage('assets/forage-net-logo.png'),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forage Classifier',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Classify forages seamlesly!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: IconButton(
                    icon: Icon(Icons.camera, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              page: ScanPage(), direction: AxisDirection.left));
                    },
                  )),
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06, vertical: screenHeight * 0.0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Classify',
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Forages',
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1877F2),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                for (var crop in forageCrops)
                  ForageCard(
                    plantName: crop.name,
                    plantImage: crop.imagePath,
                    plantDescription: crop.description,
                    onClick: () {
                      _showDialog(context, convertToCropID(crop.name));
                    },
                  ),
                SizedBox(height: screenHeight * 0.02),

                // ForageCard
              ],
            ))));
  }

  String convertToCropID(String cropName) {
    return cropName.toLowerCase().replaceAll(' ', '-');
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
