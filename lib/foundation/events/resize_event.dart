import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/size.dart';

class ResizeEvent with Event {
  final Size size;

  ResizeEvent({this.size});
}
