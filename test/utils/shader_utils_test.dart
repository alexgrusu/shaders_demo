import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shaders_demo/utils/shader_utils.dart';

void main() {
  group('[ShaderUtils] - colourArrayToHex', () {
    test('should convert RGB array to hex', () {
      // Act
      final rHex = ShaderUtils.colourArrayToHex([255, 0, 0]);
      final gHex = ShaderUtils.colourArrayToHex([0, 255, 0]);
      final bHex = ShaderUtils.colourArrayToHex([0, 0, 255]);

      // Assert
      expect(rHex, '#FF0000');
      expect(gHex, '#00FF00');
      expect(bHex, '#0000FF');
    });
  });

  group('[ShaderUtils] - hexToColourArray', () {
    test('should convert hex to RGB array', () {
      // Act
      final rArray = ShaderUtils.hexToColourArray('#FF0000');
      final gArray = ShaderUtils.hexToColourArray('#00FF00');
      final bArray = ShaderUtils.hexToColourArray('#0000FF');

      // Assert
      expect(rArray, [1.0, 0.0, 0.0]);
      expect(gArray, [0.0, 1.0, 0.0]);
      expect(bArray, [0.0, 0.0, 1.0]);
    });
  });

  group('[ShaderUtils] - hexToHsl', () {
    test('should convert hex to HSL', () {
      // Act
      final rHsl = ShaderUtils.hexToHsl('#FF0000');
      final gHsl = ShaderUtils.hexToHsl('#00FF00');
      final bHsl = ShaderUtils.hexToHsl('#0000FF');

      // Assert
      expect(rHsl.hue, 0);
      expect(rHsl.saturation, 1);
      expect(rHsl.lightness, 0.5);

      expect(gHsl.hue, 120);
      expect(gHsl.saturation, 1);
      expect(gHsl.lightness, 0.5);

      expect(bHsl.hue, 240);
      expect(bHsl.saturation, 1);
      expect(bHsl.lightness, 0.5);
    });
  });

  group('[ShaderUtils] - hslToString', () {
    test('should convert HSL to HSL string', () {
      // Arrange
      const rHsl = HSLColor.fromAHSL(1, 0, 1, 0.5);

      // Act
      final rHslString = ShaderUtils.hslToString(rHsl);

      // Assert
      expect(rHslString, 'hsl(0, 100%, 50%)');
    });
  });

  group('[ShaderUtils] - hslToHex', () {
    test('should convert HSL to hex', () {
      // Arrange
      const rHsl = HSLColor.fromAHSL(1, 0, 1, 0.5);

      // Act
      final rHex = ShaderUtils.hslToHex(rHsl);

      // Assert
      expect(rHex, '#FF0000');
    });
  });
}
