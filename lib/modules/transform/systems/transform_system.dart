import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/components/size.dart';
import 'package:fluttershy/foundation/resources/dimensions.dart';
import 'package:fluttershy/modules/transform/components/scale.dart';
import 'package:fluttershy/modules/transform/components/transform.dart';
import 'package:fluttershy/modules/transform/components/translation.dart';
import 'package:vector_math/vector_math_64.dart';

class TransformSystem extends System {
  TransformSystem()
      : super(type: [
          Transform,
          [Translation, Scale]
        ]);

  @override
  void run(World world, List<Entity> entities) {
    Size screenSize = world.getResource<Dimensions>().screenSize;

    entities.forEach((entity) {
      Transform transform = entity.getComponent<Transform>();
      Vector3 translation =
          entity.getComponent<Translation>()?.vector?.clone() ??
              transform.matrix.getTranslation();
      Vector3 scale = entity.getComponent<Scale>()?.vector ?? Vector3.all(1);

      translation.add(Vector3(0, screenSize.height - translation.y * 2, 0));

      transform.matrix.setFromTranslationRotationScale(
          translation, Quaternion.identity(), scale);
    });
  }
}
