import 'package:e_commerce_app/controllers/products_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = ChangeNotifierProvider((ref) => CartManager());
