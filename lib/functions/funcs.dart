  import 'dart:math';

double shortestAngle(double a, double b) {
    double diff = (b - a + pi) % (2 * pi) - pi;
    return diff < -pi ? diff + 2 * pi : diff;
  }
  