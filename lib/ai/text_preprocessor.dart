class TextPreprocessor {

  static String cleanText(String text) {

    text = text.toLowerCase();

    text = text.replaceAll(RegExp(r'[^a-z\s]'), '');

    text = text.replaceAll(RegExp(r'\s+'), ' ');

    return text.trim();
  }

  static List<String> tokenize(String text) {
    return text.split(" ");
  }

}