abstract class BaseApiService {
  final String baseUrl =
      "https://private-anon-a38bf09d24-pizzaapp.apiary-mock.com/";

  Future<dynamic> getResponse(String url);
  Future<dynamic> postResponse(String url, Map<String, dynamic> JsonBody);
}
