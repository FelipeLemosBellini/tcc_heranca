import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

class InheritanceRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Either<ExceptionMessage, void>> createInheritance() async {
    try {

      return Right('');
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }
}
