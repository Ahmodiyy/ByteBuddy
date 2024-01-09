import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogRepo {
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;

  Future<void> logTransactionReference(
      {required String email, required String transactionReference}) async {
    try {
      CollectionReference logCollection = _cloudStore.collection('log');
      DocumentReference documentReference = logCollection.doc(email);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> currentData =
            documentSnapshot.data() as Map<String, dynamic>;

        List<Map<String, dynamic>> transactionReferenceList =
            List<Map<String, dynamic>>.from(
                currentData['transactionReferences']);

        transactionReferenceList.add({
          'transactionReference': transactionReference,
        });
        // Update the document with the modified data
        await documentReference
            .update({'transactionReferences': transactionReferenceList});

        // Print a success message
        print('Document updated successfully!');
      } else {
        List<Map<String, dynamic>> transactionReferenceArray = [
          {
            'transactionReference': transactionReference,
          },
        ];
        Map<String, dynamic> documentData = {
          'transactionReferences': transactionReferenceArray,
        };
        // Add the document to the "log" collection with the specified ID
        await documentReference.set(documentData);
        print('Document added successfully!');
      }
    } catch (e) {
      print('Error adding or updating document to log collection: $e');
    }
  }
}

final logRepoProvider = Provider<LogRepo>((ref) {
  return LogRepo();
});
