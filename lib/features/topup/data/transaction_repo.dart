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
      debugPrint('docs lent ${transactionsDocument.length}');
      for (var element in transactionsDocument) {
        debugPrint('trans type ${element.data()["type"]}');
      }
      return transactionsDocument;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String email,
      {int limit = 10}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _cloudStore.collection("log").doc(email).get();
      List<dynamic> transactionHistory =
          documentSnapshot.data()?['transactionHistory'] ?? [];
      List<dynamic> limitedTransactions = transactionHistory.length > limit
          ? transactionHistory.sublist(0, limit)
          : transactionHistory;
      return List<Map<String, dynamic>>.from(limitedTransactions);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getNextTransactions(
      String email, int startIndex,
      {int limit = 10}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _cloudStore.collection("log").doc(email).get();
      List<dynamic> transactionHistory =
          documentSnapshot.data()?['transactionHistory'] ?? [];
      List<dynamic> nextTransactions =
          transactionHistory.length > (startIndex + limit)
              ? transactionHistory.sublist(startIndex, limit)
              : transactionHistory.sublist(startIndex);
      return List<Map<String, dynamic>>.from(nextTransactions);
    } catch (error) {
      rethrow;
    }
  }
}
