import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/parent.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/modules/transform/components/local_to_parent.dart';
import 'package:fluttershy/modules/transform/components/local_to_world.dart';
import 'package:fluttershy/modules/transform/components/scale.dart';
import 'package:fluttershy/modules/transform/components/translation.dart';
import 'package:vector_math/vector_math_64.dart';

class TransformSystem extends System {
  TransformSystem()
      : super(type: [
          LocalToWorld,
          [Translation, Scale]
        ]);

  @override
  void run(World world, List<Entity> entities) {
    // print(entities.length);

    entities.forEach((entity) {
      final worldTransform = entity.getComponent<LocalToWorld>();
      final translation = entity.getComponent<Translation>();
      final scale = entity.getComponent<Scale>();

      if (translation != null && translation.isDirty) {
        final parentTransform = entity.getComponent<LocalToParent>();
        final parent = entity.getComponent<Parent>();

        if (parent != null && parentTransform != null) {
          parentTransform.matrix.setTranslation(translation.vector);
          parentTransform.matrix
              .setTranslation(parentTransform.matrix.getTranslation()..y *= -1);
          // print(translation.vector);
        } else {
          worldTransform.matrix.setTranslation(translation.vector);
          worldTransform.matrix
              .setTranslation(worldTransform.matrix.getTranslation()..y *= -1);
        }

        translation.makeClean();
      }

      if (scale != null && scale.isDirty) {
        final parentTransform = entity.getComponent<LocalToParent>();
        final parent = entity.getComponent<Parent>();

        if (parent != null && parentTransform != null) {
          parentTransform.matrix.setEntry(0, 0, scale.vector.x);
          parentTransform.matrix.setEntry(1, 1, scale.vector.y);
          parentTransform.matrix.setEntry(2, 2, scale.vector.z);
        } else {
          worldTransform.matrix.setEntry(0, 0, scale.vector.x);
          worldTransform.matrix.setEntry(1, 1, scale.vector.y);
          worldTransform.matrix.setEntry(2, 2, scale.vector.z);
        }

        scale.makeClean();
      }
    });
  }
}
