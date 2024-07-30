import 'package:flutter_angle/flutter_angle.dart';
import 'package:shaders_demo/factory/model/render_texture_fromat.dart';
import 'package:shaders_demo/factory/model/shader_rendering_context.dart';

class RenderingContextFactory {
  ShaderRenderingContext create(FlutterAngleTexture texture) {
    final rc = texture.getContext();
    final formatRGBA =
        _getSupportedFormat(rc, WebGL.RGBA16F, WebGL.RGBA, WebGL.HALF_FLOAT);
    final formatRG =
        _getSupportedFormat(rc, WebGL.RG16F, WebGL.RG, WebGL.HALF_FLOAT);
    final formatR =
        _getSupportedFormat(rc, WebGL.R16F, WebGL.RED, WebGL.HALF_FLOAT);

    return ShaderRenderingContext(
      rc: rc,
      formatRGBA: formatRGBA,
      formatRG: formatRG,
      formatR: formatR,
    );
  }

  RenderTextureFormat? _getSupportedFormat(
    RenderingContext rc,
    int internalFormat,
    int format,
    int type,
  ) {
    if (!_supportRenderTextureFormat(rc, internalFormat, format, type)) {
      switch (internalFormat) {
        case WebGL.R16F:
          return _getSupportedFormat(rc, WebGL.RG16F, WebGL.RG, type);
        case WebGL.RG16F:
          return _getSupportedFormat(rc, WebGL.RGBA16F, WebGL.RGBA, type);
        default:
          return null;
      }
    }
    return RenderTextureFormat(
      internalFormat: internalFormat,
      format: format,
    );
  }

  bool _supportRenderTextureFormat(
    RenderingContext rc,
    int internalFormat,
    int format,
    int type,
  ) {
    final texture = rc.createTexture();
    rc.bindTexture(WebGL.TEXTURE_2D, texture);
    rc.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.NEAREST);
    rc.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.NEAREST);
    rc.texParameteri(
        WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
    rc.texParameteri(
        WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
    rc.texImage2D(
        WebGL.TEXTURE_2D, 0, internalFormat, 4, 4, 0, format, type, null);

    final fbo = rc.createFramebuffer();
    rc.bindFramebuffer(WebGL.FRAMEBUFFER, fbo);
    rc.framebufferTexture2D(WebGL.FRAMEBUFFER, WebGL.COLOR_ATTACHMENT0,
        WebGL.TEXTURE_2D, texture, 0);

    final status = rc.checkFramebufferStatus(WebGL.FRAMEBUFFER);

    if (status != WebGL.FRAMEBUFFER_COMPLETE) {
      return false;
    }
    return true;
  }
}
