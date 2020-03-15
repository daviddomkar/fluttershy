import 'package:dartex/dartex.dart';
import 'package:fluttershy/modules/transform/components/transform.dart';
import 'package:fluttershy/modules/transform/components/translation.dart';

class TranslateTransformSystem extends System {
  TranslateTransformSystem() : super(type: [Transform, Translation]);

  @override
  void run(World world, List<Entity> entities) {
    entities.forEach(
      (entity) => entity
          .getComponent<Transform>()
          .matrix
          .setTranslation(entity.getComponent<Translation>().vector),
    );
  }
}
