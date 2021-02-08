import 'package:car_rental/providers/Cars.dart';
import 'package:car_rental/screens/edit-car-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cars.dart';

class AdminCarItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
// Admin car Item code
  AdminCarItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 17),
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Color.fromRGBO(64, 61, 57, 1),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditCarScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Color.fromRGBO(254, 95, 85, 1),
              ),
              onPressed: () async {
                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'Warning',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.red, fontSize: 25),
                          ),
                          content: Text(
                            'Do you want to delete this car from your list ?',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.black, fontSize: 20),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'No',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color: Color.fromRGBO(235, 94, 40, 1),
                                        fontSize: 15),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Sure',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color: Colors.black, fontSize: 15),
                              ),
                              onPressed: () async {
                                try {
                                  await Provider.of<Cars>(context,
                                          listen: false)
                                      .deleteCar(id);
                                } catch (error) {
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Deleting failed!',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                                Navigator.of(ctx).pop(true);
                              },
                            ),
                          ],
                        ));
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
