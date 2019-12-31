import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';
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
      print(result.nonce);
      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    
  }
  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
  }
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
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
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey, fontSize: 20),
        )
      ],
    );
  }
  Future<DateTime> selectedDate(BuildContext context) async {
      final List<DateTime> picked = await DateRagePicker.showDatePicker(
          context: context,
          initialFirstDate: new DateTime.now(),
          initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
          firstDate: new DateTime(2018),
          lastDate: new DateTime(2022)
      );
      initializeDateFormatting('us');
      setState(() {
        widget.pickedRange = picked;
        widget.dateStart = DateFormat.yMMMEd().format(widget.pickedRange[0]);
        widget.dateEnd =  DateFormat.yMMMEd().format(widget.pickedRange[1]);
      });

  }
  @override
  Widget build(BuildContext context) {
  print(widget.pickedRange);
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
            Divider(
              thickness: 3,
            ),
            Center(
              child: Text(
                'Rental Duration',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w500, 
                  color: Colors.teal,
                ),
              ),
            ), 
            FlatButton(
              textColor: Colors.black54,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: widget.pickedRange == null ? 
                Text(
                  'Select Dates',
                  style: TextStyle(fontSize: 16),
                ) : 
                Column(
                  children: <Widget> [  
                    Text(
                      widget.dateStart.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'to',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      widget.dateEnd.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ), 
              onPressed: () => selectedDate(context),
            ),
            Divider(
              thickness: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.add_shopping_cart),
                  onPressed: () => selectedDate(context),
                  color: Colors.teal,
                  textColor: Colors.white,
                  
                ),
                FlatButton(
                  child: Icon(Icons.payment),
                  onPressed: () => _pay(),
                  color: Colors.teal,
                  textColor: Colors.white,
                ),
                FlatButton(
                  child: Icon(Icons.help),
                  onPressed: () => '',
                  color: Colors.teal,
                  textColor: Colors.white,
                  
                )
              ],
            )
          ],
        ),
        ),
      ),
    );
  }
}
