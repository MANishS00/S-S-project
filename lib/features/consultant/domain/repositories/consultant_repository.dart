abstract class ConsultantRepository {
  Future<void> submitConsultantRequest({
    required String name,
    required String productService,
    required String mobileNumber,
    required String email,
    required String message,
  });

  Future<List<Map<String, dynamic>>> fetchConsultantRequests(String token);
}
