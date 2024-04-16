class Product {
  int id;
  String title;
  String description;
  String imgUrl;
  dynamic rating;
  int price;
   
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imgUrl,
      required this.rating,
      required this.price});

}
