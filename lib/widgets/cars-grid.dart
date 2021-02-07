import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cars.dart';
import './car-item.dart';

class CarsGrid extends StatelessWidget {
  final bool showFavs;

  CarsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Cars>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    print(products);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: CarItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
