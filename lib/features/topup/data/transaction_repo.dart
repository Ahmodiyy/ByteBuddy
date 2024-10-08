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

final  lastTenTransactionHistoryProvider= StreamProvider.autoDispose<List<QueryDocumentSnapshot<Map<String, dynamic>>>>((ref) async* {
  final snapshots = TransactionRepo().fetchLastTenTransactionStream(
      ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
  await for (var snapshot in snapshots) {
    yield snapshot.docs;
  }

});


class TransactionRepo {
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String email) {
    var collectionReference = _cloudStore.collection('log');
    var documentReference = collectionReference.doc(email);
    return documentReference.snapshots();
  }

  Future<dynamic> getBalance(String email) async {
    var collectionReference = FirebaseFirestore.instance.collection('log');
    var documentReference = collectionReference.doc(email);

    var snapshot = await documentReference.get();
    Map<String, dynamic>? data = snapshot.data();
    dynamic balance = data?['balance'] ?? 0.0;
    return balance;
  }

  Future<List<QueryDocumentSnapshot>> fetchTransactionHistory(
      String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _cloudStore
          .collection("log")
          .doc(email)
          .collection("transactions")
          .orderBy("date", descending: true)
          .limit(10)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> transactionsDocument =
          querySnapshot.docs;
      return transactionsDocument;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchNextTransactionHistory(
      String email, DocumentSnapshot? documentSnapshot) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _cloudStore
          .collection("log")
          .doc(email)
          .collection("transactions")
          .orderBy("date", descending: true)
          .startAfterDocument(documentSnapshot!)
          .limit(10)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> transactionsDocument =
          querySnapshot.docs;

      return transactionsDocument;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchLastTenTransactionStream(
      String email) {
    try {
      return _cloudStore
          .collection("log")
          .doc(email)
          .collection("transactions")
          .orderBy("date", descending: true)
          .limit(10)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

}
