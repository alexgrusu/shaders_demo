class ShaderConfig {
  final double radius;
  final int textureDownsample;
  final double densityDissipation;
  final double velocityDissipation;
  final double pressureDissipation;
  final int pressureIterations;
  final double opacity;
  final double speed;
  final double grain;
  final double vorticity;
  final bool movement;
  final bool rainbow;
  final double rainbowSpeed;
  final Map<String, double> velocityDirection;
  final bool recording;

  const ShaderConfig({
    this.radius = 0.13,
    this.textureDownsample = 1,
    this.densityDissipation = 0.991295,
    this.velocityDissipation = 0.99999,
    this.pressureDissipation = 0.923905,
    this.pressureIterations = 100,
    this.opacity = 0.08,
    this.speed = 2,
    this.grain = 1.0,
    this.vorticity = 0,
    this.movement = true,
    this.rainbow = false,
    this.rainbowSpeed = 0.5,
    this.velocityDirection = const {'x': 0, 'y': 0},
    this.recording = false,
  });
}
