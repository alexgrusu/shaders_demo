import 'package:flutter/material.dart';

class ShaderUtils {
  static String colourArrayToHex(List<int> colourArray) {
    final r = colourArray[0];
    final g = colourArray[1];
    final b = colourArray[2];
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  static List<double> hexToColourArray(String hex) {
    final r = int.parse(hex.substring(1, 3), radix: 16);
    final g = int.parse(hex.substring(3, 5), radix: 16);
    final b = int.parse(hex.substring(5, 7), radix: 16);
    return [r / 255, g / 255, b / 255];
  }

  static HSLColor hexToHsl(String hex) {
    final color = Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
    return HSLColor.fromColor(color);
  }

  static String hslToString(HSLColor hsl) {
    final h = (hsl.hue * 100).toStringAsFixed(0);
    final s = (hsl.saturation * 100).toStringAsFixed(0);
    final l = (hsl.lightness * 100).toStringAsFixed(0);
    return 'hsl($h, $s%, $l%)';
  }

  static String hslToHex(HSLColor hsl) {
    final color = hsl.toColor();
    return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }
}
