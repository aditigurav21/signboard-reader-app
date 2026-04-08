import 'dart:convert';
import 'package:flutter/services.dart';

import 'tfidf_vectorizer.dart';
import 'logistic_classifier.dart';
import 'sign_filter.dart';

class DetectionService {

  late TFIDFVectorizer vectorizer;
  late LogisticClassifier classifier;

  bool modelLoaded = false;

  // LOAD MODEL FROM JSON
  Future<void> loadModel() async {

    final jsonString =
    await rootBundle.loadString('assets/model.json');

    final data = json.decode(jsonString);

    Map<String,int> vocabulary =
    Map<String,int>.from(data["vocabulary"]);

    List<double> weights =
    List<double>.from(data["weights"]);

    double bias = data["bias"];

    vectorizer = TFIDFVectorizer(vocabulary);

    classifier = LogisticClassifier(weights, bias);

    modelLoaded = true;

  }

  // MAIN DETECTION FUNCTION
  List<String> detect(String text) {

    if (!modelLoaded) {
      throw Exception("Model not loaded");
    }

    return SignFilter.filterText(
        text,
        vectorizer,
        classifier);

  }

}
