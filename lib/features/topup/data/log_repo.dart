import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final logRepoProvider = Provider<LogRepo>((ref) {
  return LogRepo();
});

class LogRepo {
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;

  Future<void> logTransactionReference(
      {required String email, required String transactionReference}) async {
    try {
      CollectionReference logCollection = _cloudStore.collection('log');
      DocumentReference documentReference = logCollection.doc(email);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        await updateTransactionReference(
            email: email,
            transactionReference: transactionReference,
            documentReference: documentReference,
            documentSnapshot: documentSnapshot);
      } else {
        await addTransactionReference(
            email: email,
            transactionReference: transactionReference,
            documentReference: documentReference);
      }
    } catch (e) {
      print('Error adding or updating document to log collection: $e');
    }
  }

  Future<void> addTransactionReference(
      {required String email,
      required String transactionReference,
      required DocumentReference documentReference}) async {
    try {
      List<Map<String, dynamic>> transactionReferenceArray = [
        {
          'transactionReference': transactionReference,
        },
      ];
      Map<String, dynamic> documentData = {
        'transactionReferences': transactionReferenceArray,
      };
      await documentReference.set(documentData);
      print('Document added successfully!');
    } catch (e) {
      print('Error adding to log collection: $e');
    }
  }

  Future<void> updateTransactionReference(
      {required String email,
      required String transactionReference,
      required DocumentReference documentReference,
      required DocumentSnapshot documentSnapshot}) async {
    try {
      Map<String, dynamic> currentData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> transactionReferenceList =
          List<Map<String, dynamic>>.from(currentData['transactionReferences']);

      transactionReferenceList.add({
        'transactionReference': transactionReference,
      });
      await documentReference
          .update({'transactionReferences': transactionReferenceList});

      print('Document updated successfully!');
    } catch (e) {
      print('Error updating to log collection: $e');
    }
  }
}
