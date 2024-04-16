import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  //*Search API Implementation
  Future<Map<String, dynamic>> getProducts() async {
    String apiUrl = 'https://dummyjson.com/products';

    Map<String, dynamic> data = {};

    http.Response response = await http.get(Uri.parse(apiUrl));
    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
      }
    } catch (e) {
      // print(e);
    }
    return data;
  }
}
