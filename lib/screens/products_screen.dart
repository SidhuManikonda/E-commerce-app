import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/providers/product_provider.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:e_commerce_app/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  bool displayProductsAsGrid = false;
  String enteredkeyword = '';
  List<Product> products = [];
  List filterlist = [];
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  searchfunction(String enteredkeyword) {
    filterlist.clear();
    for (var item in products) {
      if (item.title.toLowerCase().contains(enteredkeyword.toLowerCase())) {
        filterlist.add(item);
      }
    }
    setState(() {});
  }

  Future<void> getProducts() async {
    final data = await ProductService().getProducts();
    List rawProducts = data['products'];
    for (int i = 0; i < rawProducts.length; i++) {
      Product product = Product(
          id: rawProducts[i]['id'],
          title: rawProducts[i]['title'],
          description: rawProducts[i]['description'],
          imgUrl: rawProducts[i]['images'][0],
          rating: rawProducts[i]['rating'],
          price: rawProducts[i]['price']);
      products.add(product);
    }
    setState(() {});
  }

  final TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prdMngr = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-commerce App"),
        backgroundColor: Colors.blue[400],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  displayProductsAsGrid = !displayProductsAsGrid;
                  setState(() {});
                },
                child: Icon(
                  (displayProductsAsGrid) ? Icons.grid_view : Icons.list_sharp,
                  size: 35,
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildBadge(context, prdMngr.cartItems.length.toString()))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
        child: Column(
          children: [
            TextFormField(
              controller: searchcontroller,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
              onChanged: (value) {
                searchfunction(searchcontroller.text);
                setState(() {});
              },
            ),
            Expanded(
              child: (products.isEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : displayProductsAsGrid

                      // *DISPLAYS PRODUCTS IN GRID VIEW
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 0,
                            childAspectRatio: 0.6,
                            // mainAxisExtent: 8
                          ),
                          itemCount: filterlist.length,
                          itemBuilder: (context, index) {
                            final product = filterlist[index];
                            return Container(
                              margin: const EdgeInsets.all(6),
                              width: MediaQuery.of(context).size.width - 15,
                              color: Colors.grey[200],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 130,
                                    width:
                                        MediaQuery.of(context).size.width - 15,
                                    child: Image.network(
                                      product.imgUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          height: 20,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Text(
                                            product.title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.green),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          child: Text(double.parse(
                                                  product
                                                      .rating
                                                      .toStringAsFixed(1))
                                              .toString()),
                                        ))
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 6),
                                    child: SizedBox(
                                      height: 40,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(product.description),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0),
                                    child: Text(
                                      "Price: ${product.price.toString()}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: (prdMngr.cartItems.any((element) =>
                                            element.id ==
                                            product.id.toString()))
                                        ? () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const CartScreen()));
                                          }
                                        : () {
                                            prdMngr
                                                .addItemToCart(product);
                                            setState(() {});
                                          },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        height: 35,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: (prdMngr.cartItems.any(
                                                    (element) =>
                                                        element.id ==
                                                        product
                                                            .id
                                                            .toString()))
                                                ? Colors.green[400]
                                                : Colors.blue[200]),
                                        child: Center(
                                            child: (prdMngr.cartItems.any(
                                                    (element) =>
                                                        element.id ==
                                                        product
                                                            .id
                                                            .toString()))
                                                ? const Text('Go To Cart')
                                                : const Text("Add to Cart")),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          })

                      // *DISPLAYS PRODUCTS IN LIST VIEW
                      : ListView.builder(
                          itemCount: filterlist.length,
                          itemBuilder: (context, index) {
                            final product = filterlist[index];
                            // : filterlist[index];
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
                                        product.imgUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                              1.9 -
                                          6.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 6),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                    height: 24,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    child: Text(
                                                      product.title,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 22),
                                                    )),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors.green),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 2),
                                                      child: Text(double.parse(
                                                              product.rating
                                                                  .toStringAsFixed(
                                                                      1))
                                                          .toString()),
                                                    ))
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: SizedBox(
                                                  height: 40,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                    product.description,
                                                  )),
                                            ),
                                            Text(
                                              "Price : ${product.price.toString()}",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: (prdMngr.cartItems.any(
                                                      (element) =>
                                                          element.id ==
                                                          product.id
                                                              .toString()))
                                                  ? () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const CartScreen()));
                                                    }
                                                  : () {
                                                      prdMngr.addItemToCart(
                                                          product);
                                                      setState(() {});
                                                    },
                                              child: Container(
                                                height: 35,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: (prdMngr.cartItems
                                                            .any((element) =>
                                                                element.id ==
                                                                product.id
                                                                    .toString()))
                                                        ? Colors.green[400]
                                                        : Colors.blue[200]),
                                                child: Center(
                                                    child: (prdMngr.cartItems
                                                            .any((element) =>
                                                                element.id ==
                                                                product.id
                                                                    .toString()))
                                                        ? const Text(
                                                            'Go To Cart')
                                                        : const Text(
                                                            "Add to Cart")),
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
          ],
        ),
      ),
    );
  }
}

// * Badge to show the number of products in the cart
Widget buildBadge(BuildContext context, String value) {
  return Stack(
    alignment: Alignment.center,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CartScreen()));
        },
        child: const Icon(
          Icons.shopping_cart,
          size: 30,
        ),
      ),
      Positioned(
        right: -2,
        top: -2,
        child: Stack(children: [
          Container(
            constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[400],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
            ),
            constraints: const BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ]),
      )
    ],
  );
}
