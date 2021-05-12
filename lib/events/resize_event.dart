import 'package:fluttershy/events/event.dart';
import 'package:fluttershy/math.dart';

class ResizeEvent with Event<ResizeEvent> {
  final Vector2 size;

  ResizeEvent({required this.size});
}
