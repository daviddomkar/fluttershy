import 'package:fluttershy/events/event.dart';
import 'package:fluttershy/size.dart';

class ResizeEvent with Event<ResizeEvent> {
  final Size size;

  ResizeEvent({this.size});
}
