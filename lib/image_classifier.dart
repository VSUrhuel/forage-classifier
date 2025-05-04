import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassifier {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isModelReady = false;
  final int _inputSize = 224;

  Future<void> loadModelAndLabels(String modelPath, String labelPath) async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      print("Model loaded: $modelPath");
      // final labelFile = await File(labelPath).readAsString();
      // if (labelFile.isEmpty) {
      //   throw Exception('Label file is empty or not found');
      // }
      // _labels = labelFile
      //     .split('\n')
      //     .where((label) => label.trim().isNotEmpty)
      //     .map((label) => label.trim())
      //     .toList();
      _labels = [
        "carabao-grass",
        "centro",
        "gliricidia",
        "leucaena",
        "para-grass"
      ]; // Placeholder for actual labels
      print("Labels loaded: $_labels");
      if (_labels == null || _labels!.isEmpty) {
        throw Exception('Labels are empty or not loaded correctly');
      }
      _isModelReady = true;
    } catch (e) {
      _isModelReady = false;
      _interpreter?.close();
      rethrow;
    }
  }

  Future<List<List<List<List<double>>>>> preprocessImage(
      String imagePath) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) throw Exception('Image not found');

      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception('Failed to decode image');

      // Resize image to input size
      final resizedImage =
          img.copyResize(image, width: _inputSize, height: _inputSize);

      // Create 4D tensor: [1, height, width, 3]
      return [
        List.generate(
            _inputSize,
            (y) => List.generate(_inputSize, (x) {
                  final pixel = resizedImage.getPixel(x, y);
                  return [
                    img.getRed(pixel) / 255.0, // Normalize to [0,1]
                    img.getGreen(pixel) / 255.0,
                    img.getBlue(pixel) / 255.0
                  ];
                }))
      ];
    } catch (e) {
      print('Image processing error: $e');
      rethrow;
    }
  }

  Float32List _imageToFloat32List(List<List<List<List<double>>>> inputTensor) {
    final inputSize = _inputSize;
    final floatList = Float32List(inputSize * inputSize * 3);
    int index = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = inputTensor[0][y][x];
        floatList[index++] = pixel[0]; // R
        floatList[index++] = pixel[1]; // G
        floatList[index++] = pixel[2]; // B
      }
    }

    return floatList;
  }

  Future<Map<String, double>?> classifyImage(String imagePath) async {
    if (!_isModelReady || _interpreter == null || _labels == null) {
      print('Model not ready or labels not loaded');
      return null;
    }

    try {
      // 1. Preprocess image to tensor
      final inputTensor = await preprocessImage(imagePath);
      final inputBuffer = _imageToFloat32List(inputTensor);

      // 2. Prepare output buffer
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      final outputSize = outputShape.reduce((a, b) => a * b);
      final outputBuffer = Float32List(outputSize);

      // 3. Run inference
      _interpreter!.run(inputBuffer.buffer, outputBuffer.buffer);
      print('Output shape: $outputShape');
      print('Output size: $outputSize');
      // 4. Process results
      return _processOutput(outputBuffer);
    } catch (e) {
      print('Classification error: $e');
      return null;
    }
  }

  Map<String, double> _processOutput(Float32List probabilities) {
    final entries = List<MapEntry<String, double>>.generate(
      probabilities.length,
      (i) => MapEntry(_labels![i], probabilities[i]),
    );

    entries.sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(entries);
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _isModelReady = false;
  }
}
