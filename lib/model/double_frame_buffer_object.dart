import 'package:shaders_demo/model/frame_buffer_object.dart';

class DoubleFrameBufferObject {
  FrameBufferObject first;
  FrameBufferObject last;

  DoubleFrameBufferObject({
    required this.first,
    required this.last,
  });

  FrameBufferObject get read => first;

  FrameBufferObject get write => last;

  void swap() {
    final temp = read;
    first = write;
    last = temp;
  }
}
