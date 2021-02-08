import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/Rental.dart';

import '../providers/Rental.dart' as rent;

class AdminRentalItem extends StatefulWidget {
  final rent.RentalItem order;

  AdminRentalItem(this.order);

  @override
  _AdminRentalItemState createState() => _AdminRentalItemState();
}

class _AdminRentalItemState extends State<AdminRentalItem> {
  var _expanded = false;
  var _isLoading = false;
  var _isLoadingArchive = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Dismissible(
        background: Container(
          color: Color.fromRGBO(235, 94, 40, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.archive_rounded,
                color: Colors.white,
                size: 30,
              ),
              Text(
                'Archive',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(254, 95, 85, 1),
                ),
              ),
              content: Text(
                'Do you want to archive this rental?',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          Provider.of<Rentals>(context, listen: false)
              .archiveRental(widget.order);
        },
        key: Key(widget.order.id),
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
      ),
    );
  }
}
