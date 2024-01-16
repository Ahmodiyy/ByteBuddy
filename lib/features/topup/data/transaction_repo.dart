import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionReferenceProvider =
    StreamProvider.autoDispose<void>((ref) async* {
  yield TransactionRepo().getTransactionStream(
      email: ref
          .read(authControllerLoginProvider.notifier)
          .getCurrentUser()!
          .email!);
});

class TransactionRepo {
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Object?>> getTransactionStream(
      {required String email}) {
    try {
      CollectionReference logCollection = _cloudStore.collection('log');
      DocumentReference documentReference = logCollection.doc(email);
      return documentReference.get().asStream();
    } catch (e) {
      print('Error retrieving transaction reference: $e');
      rethrow;
    }
  }
}
