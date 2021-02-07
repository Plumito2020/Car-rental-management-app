import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/Rental.dart';

class RentCarCard extends StatefulWidget {
  final double price;
  final String carName;

  RentCarCard({this.price, this.carName});
  @override
  _RentCarCardState createState() => _RentCarCardState();
}

class _RentCarCardState extends State<RentCarCard> {
  DateTime _dateDeb, _dateFin;
  String _dateDebTxt, _dateFinTxt;
  bool _invalidDates = false;
  var _isLoading = false;
  double amount = 0;

  @override
  void initState() {
    _dateDebTxt = "Start Date";
    _dateFinTxt = "End Date";
    super.initState();
  }

  double getMeTheTotal() {
    double total = 0;
    if (_dateDeb != null && _dateFin != null) {
      final difference = _dateFin.difference(_dateDeb).inDays;
      total = (difference * widget.price);
    }
    setState(() {
      amount = total;
    });
    return total;
  }

  void _save() async {
    //Validates dates
    if (_dateDeb == null || _dateFin == null) {
      setState(() {
        _invalidDates = true;
      });
      return;
    } else {
      setState(() {
        _invalidDates = false;
      });
    }
    if (_dateFin.isBefore(_dateDeb)) {
      setState(() {
        _invalidDates = true;
      });
      return;
    } else {
      setState(() {
        _invalidDates = false;
      });
    }
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Rentals>(context, listen: false)
        .rentCar(amount, widget.carName, _dateDeb, _dateFin);
    setState(() {
      _isLoading = false;
    });
    print("Hello");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Rental Information",
                  style: Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 25,
                        color: Color.fromRGBO(235, 94, 40, 1),
                      ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                          color: (_invalidDates == false)
                              ? Color.fromRGBO(235, 94, 40, 1)
                              : Colors.red[600])),
                  height: 60,
                  width: double.infinity,
                  child: FlatButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        ).then((date) {
                          setState(() {
                            _dateDeb = date;
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Text(
                            (_dateDeb == null)
                                ? _dateDebTxt
                                : DateFormat.yMMMMd('en_US').format(_dateDeb),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                          color: (_invalidDates == false)
                              ? Color.fromRGBO(235, 94, 40, 1)
                              : Colors.red[600])),
                  height: 60,
                  width: double.infinity,
                  child: FlatButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1800),
                          lastDate: DateTime(2100),
                        ).then((date) {
                          setState(() {
                            _dateFin = date;
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Text(
                            (_dateFin == null)
                                ? _dateFinTxt
                                : DateFormat.yMMMMd('en_US').format(_dateFin),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Total",
                  style: TextStyle(
                    color: Color.fromRGBO(235, 94, 40, 1),
                  ),
                ),
                Text(
                  getMeTheTotal().toString() + " Dhs",
                ),
                SizedBox(
                  height: 25,
                ),
                FlatButton(
                  onPressed: () {
                    _save();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        'Confirm',
                        style: Theme.of(context).textTheme.body1.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(235, 94, 40, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
