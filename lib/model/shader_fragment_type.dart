enum ShaderFragmentType {
  clear,
  display,
  splat,
  advection,
  divergence,
  curl,
  vorticity,
  pressure,
  gradientSubtract;

  @override
  String toString() => '${super.toString().split('.').last}Frag';
}
