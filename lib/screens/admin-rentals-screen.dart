import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/user-rental-item.dart';

import '../providers/Rental.dart' show Rentals;
import '../widgets/admin-rental-item.dart';
import '../widgets/app-drawer.dart';

class AdminRentalsScreen extends StatelessWidget {
  static const routeName = '/rentals';

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<Auth>(context).isAdmin;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Your rentals'),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        backgroundColor: Color.fromRGBO(64, 61, 57, 1),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: (isAdmin)
            ? Provider.of<Rentals>(context, listen: false)
                .fetchAndSetAllRentals()
            : Provider.of<Rentals>(context, listen: false).fetchAndSetRentals(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Rentals>(
                builder: (ctx, orderData, child) => (orderData
                        .rentals.isNotEmpty)
                    ? ListView.builder(
                        itemCount: orderData.rentals.length,
                        itemBuilder: (ctx, i) => (isAdmin)
                            ? AdminRentalItem(orderData.rentals[i])
                            : UserRentalItem(orderData.rentals[i]),
                      )
                    : Center(
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset(
                                "assets/images/noOrder.png",
                              ),
                              height: 380,
                              width: 380,
                            ),
                            Text(
                              "No rentals yet !",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).popAndPushNamed('/');
                              },
                              child: Container(
                                  width: 140,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(235, 94, 40, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: Text(
                                      "Rent a Car",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
