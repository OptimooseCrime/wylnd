import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import '../widgets/ui_elements/title_default.dart';
import '../config.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

class ProductPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  CardDetails userCard;
  var pickedRange;
  var dateStart;
  var dateEnd;

  ProductPage(this.title, this.imageUrl, this.price, this.description);
  @override
  State<StatefulWidget> createState() {
    return _ProductPageState();
  }
}

class _ProductPageState extends State<ProductPage> {
  var reserveTotal;
  var reserveLength;
  Future<void> _pay() async {
    InAppPayments.setSquareApplicationId(sqrAppId);
    InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    // take payment with the card nonce details
    // you can take a charge
    // await chargeCard(result);
    print(result.card.brand);
    print(result.card.lastFourDigits);
    print(result.card.type);
    // payment finished successfully
    // you must call this method to close card entry
    InAppPayments.completeCardEntry(
        onCardEntryComplete: () => _onCardEntryComplete(result));
  }

  void _onCardEntryComplete(result) {
    // Update UI to notify user that the payment flow is finished successfully
    setState(() {
      widget.userCard = result;
    });
  }

  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }
  final chargeUrl = "https://toolchertesting.herokuapp.com/chargeForCookie";

  Future<void> chargeCard(CardDetails result, amount) async {
    var body = jsonEncode({"nonce": result.nonce, "amount": amount});
    http.Response response;
    try {
      response = await http.post(chargeUrl, body: body, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });
    } on SocketException catch (ex) {
      print("Socket Exception");
      throw Exception(ex.message);
    }
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      print("status code: 200 ##");
      print(responseBody);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    )),
                Center(
                  child: Text("Rental Complete: " + response.body),
                ),
              ],
            ),
          );
        },
      );
      return;
    } else {
      print("ERROROR");
      print(chargeUrl);
      throw Exception(responseBody);
    }
  }

  Widget _buildAddressPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
        ),
        Text(
          '\$' + widget.price.toString(),
          style:
              TextStyle(fontFamily: 'Oswald', color: Colors.grey, fontSize: 20),
        )
      ],
    );
  }

  Future<DateTime> selectedDate(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: (new DateTime.now()).add(new Duration(days: 3)),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2022));
    initializeDateFormatting('us');
    setState(() {
      widget.pickedRange = picked;
      widget.dateStart = DateFormat.yMMMEd().format(widget.pickedRange[0]);
      widget.dateEnd = DateFormat.yMMMEd().format(widget.pickedRange[1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pickedRange);
    if (widget.pickedRange == null) {
      reserveLength = 0;
    } else {
      reserveLength =
          widget.pickedRange[1].difference(widget.pickedRange[0]).inDays;
    }
    reserveTotal = reserveLength * widget.price;
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              color: Color(0xffff34b3),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => selectedDate,
            ),
          ],
          backgroundColor: Color(0xff201148),
        ),
        body: Center(
          child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 350,
                  child: Image.network(widget.imageUrl),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: TitleDefault(widget.title),
                  ),
                ),
                _buildAddressPriceRow(),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Center(
                  child: Text(
                    'Reservation Details',
                    style: TextStyle(
                      color: Color(0xffff34b3),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: 80,
                  endIndent: 80,
                ),
                ListTile(
                  title: Text('Select Dates',
                      style: widget.pickedRange == null
                          ? TextStyle(color: Color(0xff55e7ff))
                          : TextStyle(color: Color(0xffff34b3))),
                  subtitle: widget.pickedRange == null
                      ? Text("Select date to reserve item")
                      : Text(
                          widget.dateStart.toString() +
                              " to " +
                              widget.dateEnd.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                  trailing: Icon(
                    Icons.date_range,
                    color: Color(0xff00ccfd),
                  ),
                  leading: widget.pickedRange == null
                      ? Icon(
                          Icons.check_circle_outline,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.check_circle,
                          color: Color(0xff00ccfd),
                        ),
                  onTap: () => selectedDate(context),
                ),
                ListTile(
                  title: Text('Add Payment',
                      style: widget.userCard == null
                          ? TextStyle(color: Color(0xff55e7ff))
                          : TextStyle(color: Color(0xffff34b3))),
                  subtitle: widget.userCard == null
                      ? Text("Add a payment method")
                      : Text(
                          widget.userCard.card.brand.toString() +
                              " card ending in ..." +
                              widget.userCard.card.lastFourDigits,
                          style: TextStyle(fontSize: 15),
                        ),
                  leading: widget.userCard == null
                      ? Icon(
                          Icons.check_circle_outline,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.check_circle,
                          color: Color(0xff00ccfd),
                        ),
                  trailing: Icon(
                    Icons.payment,
                    color: Color(0xff00ccfd),
                  ),
                  onTap: () => _pay(),
                ),
                ListTile(
                  title: Text('Accept Terms',
                      style: widget.userCard == null
                          ? TextStyle(color: Color(0xff55e7ff))
                          : TextStyle(color: Color(0xffff34b3))),
                  subtitle: widget.userCard == null
                      ? Text(
                          "Please read and accept the terms of rental before proceeding")
                      : Text(
                          'You have accpeted our terms. Thank you.',
                          style: TextStyle(fontSize: 15),
                        ),
                  leading: widget.userCard == null
                      ? Icon(
                          Icons.check_circle_outline,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.check_circle,
                          color: Color(0xff00ccfd),
                        ),
                  trailing: Icon(
                    Icons.info_outline,
                    color: Color(0xff00ccfd),
                  ),
                  onTap: () => '',
                ),
                Divider(
                  thickness: 1,
                  indent: 80,
                  endIndent: 80,
                ),
                widget.pickedRange != null
                    ? ListTile(
                        title: Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: widget.pickedRange == null
                            ? Text('')
                            : Text(
                                "\$" +
                                    widget.price.toString() +
                                    "/day x " +
                                    widget.pickedRange[1]
                                        .difference(widget.pickedRange[0])
                                        .inDays
                                        .toString() +
                                    " day(s).........",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                        trailing: Text(
                          '\$' + reserveTotal.toString(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        leading: Text(''),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        child: Text(
                          'Please set your reservation details above. You will not be charged until you confirm your reservation.',
                        ),
                      ),
                widget.pickedRange != null
                    ? FlatButton(
                        child: Text(
                          'Press and Hold to Reserve',
                          style: TextStyle(
                            color: widget.userCard == null
                                ? Colors.white30
                                : Color(0xffff34b3),
                          ),
                        ),
                        onPressed: () {},
                        onLongPress: () {
                          chargeCard(widget.userCard, reserveTotal);
                        },
                        color: widget.userCard == null
                            ? Colors.grey
                            : Color(0xff55e7ff),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
              ]),
        ),
      ),
    );
  }
}
