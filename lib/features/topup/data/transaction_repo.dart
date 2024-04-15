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
  debugPrint(
      'THE CURRENT AUTH USER IS ${ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!}');
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

final transactionHistoryStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) async* {
  // Call the getBalance method to get the initial balance
  List<Map<String, dynamic>> initialHistory = await TransactionRepo()
      .fetchTransactionHistory(ref
          .read(authControllerLoginProvider.notifier)
          .getCurrentUser()!
          .email!);

  yield initialHistory;
  // Listen to the document snapshots and emit the 'balance' field
  final snapshots = TransactionRepo().getDocumentStream(
      ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
  await for (var snapshot in snapshots) {
    Map<String, dynamic>? data = snapshot.data();
    List<Map<String, dynamic>> transactions = [];
    List<dynamic> transactionList = data?['transactionHistory'] ?? [];
    transactions = List<Map<String, dynamic>>.from(transactionList);
    yield transactions;
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

  Future<List<Map<String, dynamic>>> fetchTransactionHistory(
      String email) async {
    List<Map<String, dynamic>> transactions = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _cloudStore.collection("log").doc(email).get();

      if (documentSnapshot.data() == null) {
        throw Exception("No transaction history");
      }

      List<dynamic> transactionList =
          documentSnapshot.data()!['transactionHistory'];
      transactions = List<Map<String, dynamic>>.from(transactionList);
    } on DioException catch (e) {
      throw Exception("Please check your internet connection and try again.");
    } on FirebaseException catch (error) {
      throw Exception("Please check your internet connection and refresh.");
    } catch (e) {
      rethrow;
    }

    return transactions;
  }
}
