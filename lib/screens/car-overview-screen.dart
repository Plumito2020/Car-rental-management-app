import 'package:car_rental/providers/Car.dart';
import 'package:car_rental/providers/Cars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app-drawer.dart';
import '../widgets/cars-grid.dart';
import '../providers/Cars.dart';

enum FilterOptions {
  Favorites,
  All,
}
enum Category {
  Electronic,
  Hardware,
  All,
}

class CarsOverviewScreen extends StatefulWidget {
  @override
  _CarsOverviewScreenState createState() => _CarsOverviewScreenState();
}

class _CarsOverviewScreenState extends State<CarsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  var _searchController = TextEditingController();

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Cars>(context).fetchAndSetCars().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        backgroundColor: Color.fromRGBO(64, 61, 57, 1),
        title: Text('Car Rental'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Search Bar

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: Icon(
                              Icons.search,
                              color: Color.fromRGBO(37, 36, 34, 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 13),
                            child: Center(
                              child: TextFormField(
                                controller: _searchController,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {},
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: "Find your car",
                                  hoverColor: Theme.of(context).accentColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide.none),
                                ),
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    Provider.of<Cars>(context)
                                        .fetchAndSetCars();
                                  } else {
                                    Provider.of<Cars>(context)
                                        .searchCar(_searchController.text);
                                  }
                                },
                                // validator: (value) {},
                                // onSaved: (value) {},
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Grid products
                Expanded(
                  child: CarsGrid(_showOnlyFavorites),
                ),
              ],
            ),
    );
  }
}
