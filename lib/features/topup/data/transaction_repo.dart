import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final transactionRepoProvider = Provider<TransactionRepo>((ref) {
  return TransactionRepo();
});

final balanceStreamProvider = StreamProvider.autoDispose<dynamic>((ref) async* {
  // Call the getBalance method to get the initial balance
  var initialBalance = await TransactionRepo().getBalance(
      ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
  yield initialBalance;
  // Listen to the document snapshots and emit the 'balance' field
  final snapshots = TransactionRepo().getDocumentStream(
      ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
  await for (var snapshot in snapshots) {
    Map<String, dynamic>? data = snapshot.data();
    dynamic balance = data?['balance'] ?? 0.0;
    yield balance;
  }
});

final transactionStreamProvider = StreamProvider.autoDispose<dynamic>((ref) async* {
  final snapshots = TransactionRepo().getTransactionStream(
      ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
  await for (var snapshot in snapshots) {
    yield snapshot.docs ?? [];
  }
});

//
// final nextTransactionStreamProvider = StreamProvider.family(DocumentSnapshot? documentSnapshot).autoDispose<dynamic>((ref) async* {
//   final snapshots = TransactionRepo().getNextTransactionStream(
//       ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
//   await for (var snapshot in snapshots) {
//     yield snapshot.docs ?? [];
//   }
// });



class TransactionRepo {
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;

  Future<dynamic> getBalance(String email) async {
    var collectionReference = _cloudStore.collection('log');
    var documentReference = collectionReference.doc(email);

    var documentRef = await documentReference.get();
    Map<String, dynamic>? data = documentRef.data();
    dynamic balance = data?['balance'] ?? 0.0;
    return balance;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(String email) {
    var collectionReference = _cloudStore.collection('log');
    var documentReference = collectionReference.doc(email);
    return documentReference.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactionStream(String email) {
    return _cloudStore
        .collection("log")
        .doc(email)
        .collection("transactions")
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNextTransactionStream(
      String email, DocumentSnapshot? documentSnapshot)  {
    try {
      return _cloudStore
          .collection("log")
          .doc(email)
          .collection("transactions")
          .orderBy("date", descending: true)
          .startAfterDocument(documentSnapshot!)
          .limit(10).snapshots();
    } catch (e) {
      rethrow;
    }
  }

}
