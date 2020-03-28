import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/resource.dart';
import 'package:fluttershy/foundation/camera.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class Node {
  final List<Node> _children;

  RootNode _root;
  Node _parent;
  Matrix4 _transform;

  Node()
      : _children = List(),
        _transform = Matrix4.identity();

  void attachChild(Node child) {
    _root.orderedNodes.add(child);
    _children.add(child);

    child._root = _root;
    child._parent = this;

    child.onAttach();
  }

  void detachChild(Node child) {
    child.onDetach();

    child._parent = null;
    child._root = null;

    _children.remove(child);
    _root.orderedNodes.remove(child);
  }

  void detachChildren() {
    for (var i = 0; i < _children.length; i++) {
      detachChild(_children[i]);
    }
  }

  void detach() {
    _parent.detachChild(this);
  }

  void onAttach() {}

  void onDetach() {}

  void onUpdate(double deltaTime) {
    _children.forEach((child) => child.onUpdate(deltaTime));
  }

  void onRender(Canvas canvas) {}

  void onEvent(Event event) {
    _children.forEach((child) => child.onEvent(event));
  }

  bool get hasChildren => _children.isNotEmpty;
  bool get hasParent => _parent != null;

  Node get parent => _parent;
  RootNode get root => _root;

  Matrix4 get transform => _transform;
  Matrix4 get worldTransform {
    if (!hasParent) {
      return _transform;
    } else {
      return _parent.worldTransform * _transform;
    }
  }
}

class RootNode extends Node {
  final OrderedSet<Node> _orderedNodes;
  final HashMap<Type, Resource> _resources;
  final List<Camera> _cameras;

  RootNode()
      : _orderedNodes = OrderedSet(
            Comparing.on((node) => node.worldTransform.getTranslation().z)),
        _resources = HashMap(),
        _cameras = List();

  @override
  void attachChild(Node child) {
    _children.add(child);

    if (child is Camera) {
      _cameras.add(child);
    } else {
      _orderedNodes.add(child);
    }

    child._root = this;
    child._parent = this;

    child.onAttach();
  }

  @override
  void detachChild(Node child) {
    child.onDetach();

    child._parent = null;
    child._root = null;

    if (child is Camera) {
      _cameras.remove(child);
    } else {
      _orderedNodes.remove(child);
    }

    _children.remove(child);
  }

  void addResource<T extends Resource>(T resource) {
    _resources[T] = resource;
  }

  bool hasResource<T extends Resource>() {
    return _resources.containsKey(T);
  }

  T getResource<T extends Resource>() {
    return _resources[T];
  }

  void removeResource<T extends Resource>() {
    _resources.remove(T);
  }

  OrderedSet<Node> get orderedNodes => _orderedNodes;
  HashMap<Type, Resource> get resources => _resources;

  bool get hasCamera => _cameras.isNotEmpty;
  Camera get camera => _cameras.last;
}
