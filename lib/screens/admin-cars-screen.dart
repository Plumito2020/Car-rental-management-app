import 'package:car_rental/screens/edit-car-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cars.dart';
import '../widgets/admin-car-item.dart';
import '../widgets/app-drawer.dart';
import './edit-car-screen.dart';

class AdminCarsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Cars>(context, listen: false).fetchAndSetCars(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditCarScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Your Products'),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        backgroundColor: Color.fromRGBO(64, 61, 57, 1),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(EditProductScreen.routeName);
        //     },
        //   ),
        // ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Cars>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: AdminCarItem(
                                    productsData.items[i].id,
                                    productsData.items[i].title,
                                    productsData.items[i].imageUrl,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
