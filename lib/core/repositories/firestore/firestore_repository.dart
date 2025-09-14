import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';

class FirestoreRepository implements FirestoreRepositoryInterface {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<ExceptionMessage, UserModel>> getUser() async {
    try {
      final doc =
          await firestore
              .collection("users")
              .doc(firebaseAuth.currentUser?.uid)
              .get();

      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!);
        return Right(user);
      } else {
        return Left(ExceptionMessage("Usuário não encontrado."));
      }
    } catch (e) {
      return Left(ExceptionMessage("Erro ao buscar usuário: ${e.toString()}"));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> createProfile(
    String uid,
    UserModel data,
  ) async {
    try {
      await firestore.collection("users").doc(uid).set(data.toMap());
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar perfil: ${e.toString()}"));
    }
  }

  Future<Either<ExceptionMessage, void>> createTestament({
    required String addressTestator,
    required TestamentModel testament,
  }) async {
    try {
      await firestore
          .collection('testamentos')
          .doc(addressTestator)
          .set(testament.toMap());
      for (HeirModel heirModel in testament.listHeir) {
        DocumentSnapshot<Map<String, dynamic>> data =
            await firestore
                .collection('listTestamentToHeir')
                .doc(heirModel.address)
                .get();
        List<dynamic> listTestament = [];
        var response = data.data();
        if (data.exists) {
          listTestament = response?["listTestament"];
        }

        if (!listTestament.contains(addressTestator)) {
          listTestament.add(addressTestator);
        }

        await firestore
            .collection('listTestamentToHeir')
            .doc(heirModel.address)
            .set({"listTestament": listTestament});
      }
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar o testamento"));
    }
  }

  Future<Either<ExceptionMessage, TestamentModel>> getTestamentByAddress(
    String myAddress,
  ) async {
    try {
      final doc =
          await firestore.collection('testamentos').doc(myAddress).get();

      if (!doc.exists) {
        return Left(ExceptionMessage("Nenhum testamento encontrado"));
      }

      if (doc.data() == null) {
        return Left(ExceptionMessage("Dados do testamento estão vazios"));
      }

      final testament = TestamentModel.fromSnapshot(doc);
      return Right(testament);
    } catch (e) {
      return Left(
        ExceptionMessage("Erro ao buscar o testamento: ${e.toString()}"),
      );
    }
  }

  Future<Either<ExceptionMessage, List<TestamentModel>>> getHeirTestament(
    String myAddress,
  ) async {
    try {
      final list =
          await firestore
              .collection("listTestamentToHeir")
              .doc(myAddress)
              .get();
      if (!list.exists) {
        return Left(ExceptionMessage("Nenhum testamento encontrado"));
      }
      if (list.data() == null) {
        return Left(ExceptionMessage("Dados do testamento estão vazios"));
      }

      List<dynamic> listTestament = [];
      var response = list.data();
      listTestament = response?["listTestament"];

      List<TestamentModel> listTestamentModel = [];
      for (var testamentAddress in listTestament) {
        final doc =
            await firestore
                .collection('testamentos')
                .doc(testamentAddress)
                .get();

        if (!doc.exists) {
          return Left(ExceptionMessage("Nenhum testamento encontrado"));
        }

        if (doc.data() == null) {
          return Left(ExceptionMessage("Dados do testamento estão vazios"));
        }

        final testament = TestamentModel.fromSnapshot(doc);

        listTestamentModel.add(testament);
      }

      return Right(listTestamentModel);
    } catch (e) {
      return Left(
        ExceptionMessage("Erro ao buscar o testamento: ${e.toString()}"),
      );
    }
  }

  Future<Either<ExceptionMessage, void>> updateTestament({
    required String addressTestator,
    required TestamentModel testament,
  }) async {
    try {
      await firestore
          .collection('testamentos')
          .doc(addressTestator)
          .update(testament.toMap());
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao atualizar o testamento"));
    }
  }

  Future<Either<ExceptionMessage, void>> deleteTestament({
    required String address,
    required TestamentModel testament,
  }) async {
    try {
      await firestore.collection('testamentos').doc(address).delete();

      for (HeirModel heir in testament.listHeir) {
        DocumentReference<Map<String, dynamic>> docRef = firestore
            .collection('listTestamentToHeir')
            .doc(heir.address);

        DocumentSnapshot<Map<String, dynamic>> listTestamentToHeir =
            await docRef.get();

        if (listTestamentToHeir.exists) {
          List<dynamic> listTestament =
              listTestamentToHeir.data()?['listTestament'] ?? [];

          listTestament.remove(address);

          await docRef.update({'listTestament': listTestament});
        }
      }

      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao excluir testamento"));
    }
  }

  Future<Either<ExceptionMessage, void>> updateBalance({
    required double balance,
  }) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      await firestore.collection('users').doc(uid).update({'balance': balance});
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao atualizar saldo"));
    }
  }

  Future<Either<ExceptionMessage, void>> rescueInheritance(
    TestamentModel testamentModel,
    String beneficiary,
  ) async {
    try {
      TestamentModel newTestament = testamentModel;

      for (HeirModel heir in newTestament.listHeir) {
        if (beneficiary == heir.address) {
          if (heir.canWithdraw) {
            heir.canWithdraw = false;
            final userData =
                await firestore
                    .collection("users")
                    .doc(firebaseAuth.currentUser?.uid)
                    .get();

            if (userData.exists && userData.data() != null) {
              UserModel user = UserModel.fromMap(userData.data()!);

              await firestore
                  .collection("users")
                  .doc(firebaseAuth.currentUser?.uid)
                  .update(user.toMap());

              await firestore
                  .collection("testamentos")
                  .doc(testamentModel.testamentAddress)
                  .update(newTestament.toMap());
            }
          } else {
            return Left(ExceptionMessage("Você nã pode sacar."));
          }
          break;
        }
      }
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao resgatar heranca"));
    }
  }
}
