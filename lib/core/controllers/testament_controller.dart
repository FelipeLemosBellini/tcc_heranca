import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/core/enum/EnumPlan.dart';
import 'package:tcc/core/enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';

class TestamentController extends ChangeNotifier {
  TestamentModel _testament = TestamentModel.createWithDefaultValues();

  List<TestamentModel> listTestament = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  TestamentModel get testament => _testament;

  void setId() {
    _testament.id = DateTime.now().microsecondsSinceEpoch;
    notifyListeners();
  }

  void setTitle(String title) {
    _testament.title = title;
    notifyListeners();
  }

  void setDateCreated(DateTime date) {
    _testament.dateCreated = date;
    notifyListeners();
  }

  void setDateLastProveOfLife(DateTime date) {
    _testament.lastProveOfLife = date;
    notifyListeners();
  }

  void setListHeir(List<HeirModel> listHeir) {
    _testament.listHeir = listHeir;
    notifyListeners();
  }

  void setProveOfLiveRecurring(EnumProveOfLiveRecurring value) {
    _testament.proveOfLiveRecurring = value;
    notifyListeners();
  }

  void setValue(double value) {
    _testament.value = value;
    notifyListeners();
  }

  void setPlan(EnumPlan value) {
    _testament.plan = value;
    notifyListeners();
  }

  void clearTestament() {
    _testament = TestamentModel.createWithDefaultValues();
    notifyListeners();
  }

  void setUserId() {
    _testament.userId = auth.currentUser!.uid;
    notifyListeners();
  }

  Future<void> saveTestament() async {
    setId();
    setUserId();
    await firestore
        .collection('testamentos')
        .doc(_testament.id.toString())
        .set(_testament.toMap());
    notifyListeners();
  }

  Future<List<TestamentModel>> getAllTestaments() async {
    final snapshot = await firestore.collection('testamentos').get();
    listTestament = snapshot.docs
        .map((doc) => TestamentModel.fromMap(doc.data()))
        .where((testament) => testament.userId == auth.currentUser!.uid)
        .toList();
    notifyListeners();
    return listTestament;
  }

  Future<void> updateTestament() async {
    await firestore
        .collection('testamentos')
        .doc(_testament.id.toString())
        .update(_testament.toMap());

    int index = listTestament.indexWhere((t) => t.id == _testament.id);
    if (index != -1) {
      listTestament[index] = _testament;
      notifyListeners();
    }
  }

  Future<void> deleteTestament(TestamentModel oldTestament) async {
    await firestore
        .collection('testamentos')
        .doc(oldTestament.id.toString())
        .delete();

    listTestament.removeWhere((t) => t.id == oldTestament.id);
    notifyListeners();
  }

  void setTestamentToEdit(TestamentModel oldTestament) {
    _testament = oldTestament;
    notifyListeners();
  }
}
