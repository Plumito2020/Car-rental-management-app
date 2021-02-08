import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/car-detail-screen.dart';
import '../providers/Car.dart';

import '../providers/auth.dart';

class CarItem extends StatelessWidget {
  @override
  // Car item code 
  Widget build(BuildContext context) {
    final product = Provider.of<Car>(context, listen: false);

    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              CarDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: Container(
          height: 70,
          child: GridTileBar(
            backgroundColor: Color.fromRGBO(64, 61, 57, 1),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            subtitle: Text(product.price.toString() + " Dhs/Day"),
            trailing: Consumer<Car>(
              builder: (ctx, product, _) => InkWell(
                child: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  product.toggleFavoriteStatus(
                    authData.token,
                    authData.userId,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
