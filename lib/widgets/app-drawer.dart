import 'package:car_rental/screens/admin-cars-screen.dart';
import 'package:car_rental/screens/admin-rentals-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../screens/orders_screen.dart';
// import '../screens/user_products_screen.dart';
import '../providers/auth.dart';
// import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<Auth>(context).isAdmin;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome!'),
            backgroundColor: Color.fromRGBO(235, 94, 40, 1),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Catalogue',
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 17),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Rentals',
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 17),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AdminRentalsScreen.routeName);
            },
          ),
          if (isAdmin) Divider(),
          if (isAdmin)
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                'Manage my Cars',
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AdminCarsScreen.routeName);
              },
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 17),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
