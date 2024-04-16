import 'package:e_commerce_app/models/product_model.dart';

class CartItem {
  String id;
  Product product;
  int quantity;
  bool isInCart;

  CartItem(
      {required this.id,
      required this.product,
      required this.quantity,
      required this.isInCart});
}
