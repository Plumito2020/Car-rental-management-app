import 'package:car_rental/screens/admin-cars-screen.dart';
import 'package:car_rental/screens/edit-car-screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final textTheme = Theme.of(context).textTheme;
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
            textTheme: GoogleFonts.openSansTextTheme(textTheme).copyWith(
              body1: GoogleFonts.quicksand(
                fontSize: 25,
              ),
              body2: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              title: GoogleFonts.openSans(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            AdminCarsScreen.routeName: (ctx) => AdminCarsScreen(),
            EditCarScreen.routeName: (ctx) => EditCarScreen(),
          },
        ),
      ),
    );
  }
}
