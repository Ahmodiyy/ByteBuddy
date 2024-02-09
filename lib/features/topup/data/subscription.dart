abstract class Subscription {
  Future<Map<String, dynamic>> buy(
      String serviceID, int planIndex, String phone, String email);
}
