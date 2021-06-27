import 'package:fluttershy/events/event.dart';
import 'package:fluttershy/math.dart';

class ResizeEvent with Event {
  final Vector2 size;

  ResizeEvent({required this.size});
}
