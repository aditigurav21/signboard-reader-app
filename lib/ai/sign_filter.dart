import 'text_preprocessor.dart';
import 'sign_keywords.dart';

class SignFilter {

  static List<String> filterText(String text) {

    text = TextPreprocessor.clean(text);

    List<String> results = [];

    for (var category in signKeywords.keys) {

      for (var keyword in signKeywords[category]!) {

        if (text.contains(keyword)) {
          results.add(keyword);
        }

      }

    }

    return results;

  }

}
