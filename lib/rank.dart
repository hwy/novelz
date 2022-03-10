import 'package:flutter/material.dart';

//list viewpage
class Rank extends StatelessWidget {
  //透過資料產生器，產生資料
  final List<Product> listItems = new List<Product>.generate(10, (i) {
    return Product(
      name: '測試資料 $i',
      price: '售價：$i',
    );
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.event_seat),
              title: Text('${listItems[index].name}'),
              subtitle: Text('${listItems[index].price}'),
            );
          },
        ));
  }
}

//產品資料
class Product {
  final String name;
  final String price;

  Product({this.name, this.price});
}