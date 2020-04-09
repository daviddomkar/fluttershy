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
    _children.add(child);
    child._parent = this;

    if (hasRoot) {
      _attachChildRecursive(child);
    }
  }

  void _attachChildRecursive(Node child) {
    if (child is Camera) {
      _root._cameras.add(child);
    } else {
      _root._orderedNodes.add(child);
    }
    child._root = root;
    child.onAttach();
    child.children.forEach((child) => _attachChildRecursive(child));
  }

  void detachChild(Node child) {
    if (hasRoot) {
      _detachChildRecursive(child);
    }

    child._parent = null;
    _children.remove(child);
  }

  void _detachChildRecursive(Node child) {
    child.children.forEach((child) => _detachChildRecursive(child));
    child.onDetach();
    child._root = null;
    if (child is Camera) {
      _root._cameras.remove(child);
    } else {
      _root._orderedNodes.remove(child);
    }
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

  void translate(double x, [double y = 0, double z = 0]) {
    transform.translate(
      x / transform.getRow(0).x,
      y / transform.getRow(1).y,
      z / transform.getRow(2).z,
    );
  }

  bool get hasChildren => _children.isNotEmpty;
  bool get hasParent => _parent != null;
  bool get hasRoot => _root != null;

  List<Node> get children => _children;
  Node get parent => _parent;
  RootNode get root => _root;

  Vector3 get translation => transform.getTranslation();

  Vector3 get scale => Vector3(
        transform.getRow(0).x,
        transform.getRow(1).y,
        transform.getRow(2).z,
      );

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
        _cameras = List() {
    _root = this;
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
