import 'package:car_rental/widgets/rent-car-card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cars.dart';

class CarDetailScreen extends StatelessWidget {
  static const routeName = '/car-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Cars>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromRGBO(37, 36, 34, 1),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              expandedHeight: 400,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loadedProduct.title,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              loadedProduct.price.toString() + " Dhs/Day",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (ctx) => RentCarCard(
                                    price: loadedProduct.price,
                                    carName: loadedProduct.title,
                                  ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                              width: 130,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(235, 94, 40, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  "RENT IT !!",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              loadedProduct.description,
                              softWrap: true,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Category ",
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(235, 94, 40, 1),
                            ),
                          ),
                          Text(
                            loadedProduct.category,
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Consommation Moyenne",
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(235, 94, 40, 1),
                            ),
                          ),
                          Text(
                            loadedProduct.consommation.toString() + " Litre/Km",
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 800,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
