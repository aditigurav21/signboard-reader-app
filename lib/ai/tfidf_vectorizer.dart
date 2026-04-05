class TFIDFVectorizer {

  Map<String, int> vocabulary = {};

  void buildVocabulary(List<String> texts) {

    int index = 0;

    for (var text in texts) {

      for (var word in text.split(" ")) {

        if (!vocabulary.containsKey(word)) {
          vocabulary[word] = index;
          index++;
        }

      }

    }

  }

  List<double> transform(String text) {

    List<double> vector = List.filled(vocabulary.length, 0);

    var words = text.split(" ");

    for (var word in words) {

      if (vocabulary.containsKey(word)) {

        int idx = vocabulary[word]!;

        vector[idx] += 1;

      }

    }

    return vector;

  }

}
