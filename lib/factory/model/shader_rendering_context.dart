import 'package:flutter_angle/flutter_angle.dart';
import 'package:shaders_demo/factory/model/render_texture_fromat.dart';

class ShaderRenderingContext {
  final RenderingContext rc;
  final RenderTextureFormat? formatRGBA;
  final RenderTextureFormat? formatRG;
  final RenderTextureFormat? formatR;

  const ShaderRenderingContext({
    required this.rc,
    this.formatRGBA,
    this.formatRG,
    this.formatR,
  });
}
