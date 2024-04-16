// ignore_for_file: unnecessary_null_comparison

import 'package:e_commerce_app/models/cart_item_model.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter/material.dart';

class CartManager extends ChangeNotifier {
  List<CartItem> cartItems = [];

  int totalCartValue = 0;

  // *Add product to the cart
  void addItemToCart(Product product) {
    if (cartItems.isEmpty) {
      CartItem item = CartItem(
        id: product.id.toString(),
        product: Product(
          id: product.id,
          title: product.title,
          description: product.description,
          imgUrl: product.imgUrl,
          rating: product.rating,
          price: product.price,
        ),
        quantity: 1,
        isInCart: true,
      );
      cartItems.add(item);
    } else {
      if (cartItems.any((element) => element.id == product.id.toString())) {
        // If item with same ID already exists, do nothing
        return;
      } else {
        CartItem item = CartItem(
          id: product.id.toString(),
          product: Product(
            id: product.id,
            title: product.title,
            description: product.description,
            imgUrl: product.imgUrl,
            rating: product.rating,
            price: product.price,
          ),
          quantity: 1,
          isInCart: true,
        );
        cartItems.add(item);
      }
    }
    notifyListeners();
  }

// * Delete Item from Cart
  void removeItem(String productId) {
    cartItems.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

// * Quantity increment
  void qIncrement(String prodId) {
    var cartItem = cartItems.firstWhere(
      (element) => element.id == prodId,
    );
    if (cartItem != null) {
      cartItem.quantity++;
      notifyListeners();
    }
  }

// * Quantity decrement
  void qDecrement(String prodId) {
    var cartItem = cartItems.firstWhere(
      (element) => element.id == prodId,
    );
    if (cartItem != null && cartItem.quantity > 1) {
      cartItem.quantity--;
      notifyListeners();
    }
  }

// * Get Total cart value without GST
  int getTotalCartValue() {
    totalCartValue = 0;
    for (var cartItem in cartItems) {
      totalCartValue += cartItem.product.price * cartItem.quantity;
    }
    return totalCartValue;
  }

// *GST Calculation
  double calculateGST() {
    getTotalCartValue();
    double gst = totalCartValue * 0.18;
    return gst;
  }

// * Total payable amount including GST
  double totalAmount() {
    double totalAmount = getTotalCartValue() + calculateGST();
    return totalAmount;
  }
}
