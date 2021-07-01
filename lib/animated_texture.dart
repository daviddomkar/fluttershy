import 'texture.dart';

class AnimatedTexture extends Texture {
  double frameTime;

  final List<Texture> _frames;

  double _currentFrameTime;
  int _currentFrameIndex;

  AnimatedTexture.fromTextures(List<Texture> frames, {this.frameTime = 1 / 60})
      : assert(frames.isNotEmpty),
        _frames = frames,
        _currentFrameTime = 0.0,
        _currentFrameIndex = 0,
        super.fromImage(
          frames[0].image,
          position: frames[0].position,
          size: frames[0].size,
          trimOffset: frames[0].trimOffset,
          trimSize: frames[0].trimSize,
        );

  void update(double deltaTime) {
    _currentFrameTime += deltaTime;

    while (_currentFrameTime > frameTime) {
      _currentFrameTime -= frameTime;

      if (_currentFrameIndex != _frames.length - 1) {
        _currentFrameIndex++;
      } else {
        _currentFrameIndex = 0;
      }

      image = _frames[_currentFrameIndex].image;
      position = _frames[_currentFrameIndex].position;
      size = _frames[_currentFrameIndex].size;
      trimOffset = _frames[_currentFrameIndex].trimOffset;
      trimSize = _frames[_currentFrameIndex].trimSize;
    }
  }
}
