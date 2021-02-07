import 'package:car_rental/screens/admin-cars-screen.dart';
import 'package:car_rental/screens/edit-car-screen.dart';

import './providers/Cars.dart';
import 'package:car_rental/providers/auth.dart';
import 'package:car_rental/screens/car-overview-screen.dart';
import 'package:car_rental/screens/car-detail-screen.dart';
import 'package:car_rental/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/auth-screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Cars>(
          update: (ctx, auth, previousProducts) => Cars(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(64, 61, 57, 1),
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home:
              //  AdminCarsScreen(),
              auth.isAuth
                  ? CarsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
          routes: {
            CarDetailScreen.routeName: (ctx) => CarDetailScreen(),
            // OrdersScreen.routeName: (ctx) => OrdersScreen(),
            // UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditCarScreen.routeName: (ctx) => EditCarScreen(),
          },
        ),
      ),
    );
  }
}
