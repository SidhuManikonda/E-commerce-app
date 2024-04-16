import 'package:e_commerce_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartMnrg = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart (${cartMnrg.cartItems.length})"),
        backgroundColor: Colors.blue[400],
        // leadingWidth: 30,
        titleSpacing: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: cartMnrg.cartItems.length,
                itemBuilder: (_, index) {
                  return Container(
                      margin: const EdgeInsets.all(6),
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      color: Colors.grey[200],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 160,
                            width: 160,
                            child: Image.network(
                              cartMnrg.cartItems[index].product.imgUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width / 1.9 - 6.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 24,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Text(
                                            cartMnrg
                                                .cartItems[index].product.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 22),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.green),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          child: Text(
                                            double.parse(
                                              cartMnrg.cartItems[index].product
                                                  .rating
                                                  .toStringAsFixed(1),
                                            ).toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          cartMnrg.cartItems[index].product
                                              .description,
                                        )),
                                  ),
                                  Text(
                                    "Price : ${cartMnrg.cartItems[index].product.price.toString()}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              cartMnrg.qIncrement(
                                                  cartMnrg.cartItems[index].id);
                                            },
                                            child: const Icon(Icons.add)),
                                        SizedBox(
                                          width: 30,
                                          child: Center(
                                              child: Text(cartMnrg
                                                  .cartItems[index].quantity
                                                  .toString())),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              cartMnrg.qDecrement(
                                                  cartMnrg.cartItems[index].id);
                                            },
                                            child: const Icon(Icons.remove)),
                                        const Spacer(),
                                        GestureDetector(
                                            onTap: () {
                                              cartMnrg.removeItem(
                                                  cartMnrg.cartItems[index].id);
                                            },
                                            child: const Icon(
                                              Icons.delete_outline_rounded,
                                              size: 30,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 10,
              child: Container(
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      totalRow("Total Cart Value",
                          cartMnrg.getTotalCartValue().toString()),
                      totalRow(
                          "GST (18%)",
                          double.parse(
                                  cartMnrg.calculateGST().toStringAsFixed(2))
                              .toString()),
                      totalRow(
                          "Total Amount",
                          double.parse(
                                  cartMnrg.totalAmount().toStringAsFixed(2))
                              .toString())
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget totalRow(String text, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
