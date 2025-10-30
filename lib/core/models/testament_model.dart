import 'package:cloud_firestore/cloud_firestore.dart';

class TestamentModel {
  String testamentAddress;
  DateTime dateCreated;
  double value;

  TestamentModel({
    required this.testamentAddress,
    required this.value,
    required this.dateCreated,
  });

  factory TestamentModel.createWithDefaultValues() {
    return TestamentModel(
      testamentAddress: '',

      dateCreated: DateTime.now(),
      value: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'testamentAddress': testamentAddress,
      'dateCreated': dateCreated.toIso8601String(),
      'value': value,
    };
  }

  factory TestamentModel.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return TestamentModel(
      testamentAddress: doc["testamentAddress"],
      value: doc["value"],
      dateCreated: doc["dateCreated"],
    );
  }

  factory TestamentModel.fromMap(Map<String, dynamic> map) {
    return TestamentModel(
      testamentAddress: map['testament'],
      dateCreated: DateTime.parse(map['dateCreated']),
      value: (map['value'] as num).toDouble(),
    );
  }

  factory TestamentModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return TestamentModel.fromMap({...data, 'testament': doc.id});
  }

  TestamentModel copyWith({
    String? testamentAddress,
    DateTime? dateCreated,
    double? value,
  }) {
    return TestamentModel(
      testamentAddress: testamentAddress ?? this.testamentAddress,
      dateCreated: dateCreated ?? this.dateCreated,
      value: value ?? this.value,
    );
  }
}
