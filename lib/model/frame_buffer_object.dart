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

  dynamic operator [](int index) {
    switch (index) {
      case 0:
        return texture;
      case 1:
        return fbo;
      case 2:
        return texId;
      default:
        throw RangeError.index(index, this);
    }
  }
}
