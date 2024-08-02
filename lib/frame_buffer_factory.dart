import 'package:flutter_angle/flutter_angle.dart';
import 'package:shaders_demo/model/double_frame_buffer_object.dart';
import 'package:shaders_demo/model/frame_buffer_object.dart';

class FrameBufferFactory {
  static FrameBufferObject createFBO(
    RenderingContext rc, {
    required int texId,
    required int width,
    required int height,
    required int internalFormat,
    required int format,
    required int type,
    required int param,
  }) {
    rc.activeTexture(WebGL.TEXTURE0 + texId);
    final texture = rc.createTexture();
    rc.bindTexture(WebGL.TEXTURE_2D, texture);
    rc.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, param);
    rc.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, param);
    rc.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
    rc.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
    rc.texImage2D(WebGL.TEXTURE_2D, 0, internalFormat, width, height, 0, format,type, null);

    final fbo = rc.createFramebuffer();
    rc.bindFramebuffer(WebGL.FRAMEBUFFER, fbo);
    rc.framebufferTexture2D(WebGL.FRAMEBUFFER, WebGL.COLOR_ATTACHMENT0,WebGL.TEXTURE_2D, texture, 0);
    rc.viewport(0, 0, width, height);
    rc.clear(WebGL.COLOR_BUFFER_BIT);

    return FrameBufferObject(texture: texture, fbo: fbo, texId: texId);
  }

  static DoubleFrameBufferObject createDoubleFBO(
    RenderingContext rc, {
    required int texId,
    required int width,
    required int height,
    required int internalFormat,
    required int format,
    required int type,
    required int param,
  }) {
    final firstFBO = createFBO(
      rc,
      texId: texId,
      width: width,
      height: height,
      internalFormat: internalFormat,
      format: format,
      type: type,
      param: param,
    );

    final secondFBO = createFBO(
      rc,
      texId: texId + 1,
      width: width,
      height: height,
      internalFormat: internalFormat,
      format: format,
      type: type,
      param: param,
    );
    return DoubleFrameBufferObject(first: firstFBO, last: secondFBO);
  }
}
