import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceStreamProvider = StreamProvider<dynamic>((ref) async* {
  // Call the getBalance method to get the initial balance
  var initialBalance = await TransactionRepo.getBalance(
      ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
  yield initialBalance;
  // Listen to the document snapshots and emit the 'balance' field
  final snapshots = TransactionRepo.getDocumentStream(
      ref.read(authControllerLoginProvider.notifier).getCurrentUser()!.email!);
  await for (var snapshot in snapshots) {
    Map<String, dynamic>? data = snapshot.data();
    dynamic balance = data?['balance'] ?? 0.0;
    print('balance is $balance');
    yield balance;
  }
});

class TransactionRepo {
  static final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String email) {
    var collectionReference = _cloudStore.collection('log');
    var documentReference = collectionReference.doc(email);
    return documentReference.snapshots();
  }

  static Future<dynamic> getBalance(String documentId) async {
    var collectionReference = FirebaseFirestore.instance.collection('log');
    var documentReference = collectionReference.doc(documentId);

    var snapshot = await documentReference.get();
    Map<String, dynamic>? data = snapshot.data();
    dynamic balance = data?['balance'] ?? 0.0;
    return balance;
  }
}