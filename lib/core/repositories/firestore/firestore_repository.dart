import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';

class FirestoreRepository implements FirestoreRepositoryInterface {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<ExceptionMessage, void>> getUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userResponse =
          await firestore.collection("").doc(firebaseAuth.currentUser?.uid).get();

      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(""));
    }
  }
}
