import 'package:fluttershy/event.dart';
import 'package:fluttershy/size.dart';

class ResizeEvent with Event {
  final Size size;

  ResizeEvent({this.size});
}
