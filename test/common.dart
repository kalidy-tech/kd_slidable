import 'package:flutter_test/flutter_test.dart';
import 'package:kd_slidable/src/controller.dart';
import 'package:mocktail/mocktail.dart';

class MockSlidableController extends Mock implements SlidableController {}

extension CommonFindersX on CommonFinders {
  Finder byTypeOf<T>() => byType(T);
}
