import 'package:car_rental/providers/Cars.dart';
import 'package:car_rental/screens/edit-car-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cars.dart';

class AdminCarItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

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
              onPressed: () {
                // try {
                //   await Provider.of<Cars>(context, listen: false)
                //       .deleteProduct(id);
                // } catch (error) {
                //   scaffold.showSnackBar(
                //     SnackBar(
                //       content: Text(
                //         'Deleting failed!',
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   );
                // }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
