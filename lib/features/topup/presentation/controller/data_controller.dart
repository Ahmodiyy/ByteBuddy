import 'dart:async';

import 'package:bytebuddy/features/topup/data/data_repo.dart';
import 'package:bytebuddy/features/topup/model/data_service_model.dart';
import 'package:bytebuddy/features/topup/presentation/view/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataControllerProvider =
    AsyncNotifierProvider.autoDispose<DataController, DataServiceModel>(() {
  return DataController();
});

class DataController extends AutoDisposeAsyncNotifier<DataServiceModel> {
  @override
  FutureOr<DataServiceModel> build() {
    state = const AsyncLoading();
    return ref
        .watch(dataRepoProvider)
        .getDataPlans(ref.read(networkDataProvider));
  }
}
