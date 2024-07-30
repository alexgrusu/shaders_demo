import 'package:flutter_angle/flutter_angle.dart';

class FrameBufferObject {
  final WebGLTexture texture;
  final Framebuffer fbo;
  final int texId;

  const FrameBufferObject({
    required this.texture,
    required this.fbo,
    required this.texId,
  });
}
