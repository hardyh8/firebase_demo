import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterHelper {
  static void go(BuildContext context, String location, {Object? extra}) {
    context.goNamed(location, extra: extra);
  }

  static void push(BuildContext context, String location, {Object? extra}) {
    context.pushNamed(location, extra: extra);
  }

  static void pop<T>(BuildContext context, {T? data}) {
    return context.pop(data);
  }
}
