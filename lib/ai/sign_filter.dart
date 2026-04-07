import 'text_preprocessor.dart';
import 'sign_keywords.dart';
import 'tfidf_vectorizer.dart';
import 'logistic_classifier.dart';

class SignFilter {

  static List<String> filterText(
      String text,
      TFIDFVectorizer vectorizer,
      LogisticClassifier classifier) {

    text = TextPreprocessor.cleanText(text);

    List<String> results = [];

    List<String> lines = text.split("\n");

    for (var line in lines) {

      // 1️⃣ KEYWORD CHECK FIRST
      bool keywordFound = false;

      for (var category in signKeywords.keys) {

        for (var keyword in signKeywords[category]!) {

          if (line.contains(keyword)) {

            results.add(line);
            keywordFound = true;
            break;

          }

        }

        if (keywordFound) break;

      }

      // If keyword found skip ML
      if (keywordFound) continue;

      // 2️⃣ USE ML MODEL

      List<double> vector = vectorizer.transform(line);

      double probability = classifier.predict(vector);

      if (probability > 0.75) {

        results.add(line);

      }

    }

    return results;

  }

}
