import 'package:tcc/core/models/testament_model.dart';

class TestamentCreatedEvent {
  final TestamentModel testament;

  TestamentCreatedEvent(this.testament);
}