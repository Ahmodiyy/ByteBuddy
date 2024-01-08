import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogRepo {
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;

  Future<DocumentReference<Map<String, dynamic>>> log(
      {required String name, required String site}) async {
    return await _cloudStore.collection('Log').add({
      'Name': name,
      'Site': site,
      'Time': FieldValue.serverTimestamp(),
    }).timeout(const Duration(seconds: 10));
  }
}

final logRepoProvider = Provider<LogRepo>((ref) {
  return LogRepo();
});
