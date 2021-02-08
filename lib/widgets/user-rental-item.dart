import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/Rental.dart';

import '../providers/Rental.dart' as rent;

class UserRentalItem extends StatefulWidget {
  final rent.RentalItem order;

  UserRentalItem(this.order);

  @override
  _UserRentalItemState createState() => _UserRentalItemState();
}

class _UserRentalItemState extends State<UserRentalItem> {
  var _expanded = false;
  var _isLoading = false;
  var _isLoadingArchive = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          ListTile(
            title: Text(
              '${widget.order.carName}',
              style: Theme.of(context).textTheme.body1.copyWith(
                    color: Color.fromRGBO(235, 94, 40, 1),
                    fontSize: 20,
                  ),
            ),
            subtitle: Text(
              'Total : ${widget.order.total} Dhs',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: 65,
              child: ListView(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: Color.fromRGBO(235, 94, 40, 1),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "From " +
                            DateFormat.yMMMMd('en_US')
                                .format(widget.order.startDate) +
                            " to " +
                            DateFormat.yMMMMd('en_US')
                                .format(widget.order.endDate),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
        ]),
      ),
    );
  }
}
