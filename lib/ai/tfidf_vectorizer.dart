class TFIDFVectorizer {

  Map<String, int> vocabulary;

  TFIDFVectorizer(this.vocabulary);

  List<double> transform(String text) {

    List<double> vector = List.filled(vocabulary.length, 0);

    List<String> words = text.split(" ");

    // Unigrams
    for (String word in words) {

      if (vocabulary.containsKey(word)) {
        int idx = vocabulary[word]!;
        vector[idx] += 1;
      }

    }

    // Bigrams (NEW IMPROVEMENT)
    for (int i = 0; i < words.length - 1; i++) {

      String bigram = "${words[i]} ${words[i+1]}";

      if (vocabulary.containsKey(bigram)) {

        int idx = vocabulary[bigram]!;
        vector[idx] += 1;

      }

    }

    return vector;

  }


}
