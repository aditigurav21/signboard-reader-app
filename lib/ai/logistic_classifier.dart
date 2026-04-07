import 'dart:math';

class LogisticClassifier {

  List<double> weights;

  double bias;

  LogisticClassifier(this.weights, this.bias);

  double sigmoid(double z) {
    return 1 / (1 + exp(-z));
  }

  double predict(List<double> features) {

    double z = bias;

    for (int i = 0; i < weights.length; i++) {
      z += weights[i] * features[i];
    }

    return sigmoid(z);

  }

}