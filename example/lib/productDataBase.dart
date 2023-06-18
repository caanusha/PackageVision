
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ProductARView.dart';

class RealtimeDatabaseDataPage extends StatefulWidget {
  const RealtimeDatabaseDataPage({
    Key? key,
    required this.textInput,
  }) : super(key: key);

  final String textInput;

  @override
  _RealtimeDatabaseDataPageState createState() =>
      _RealtimeDatabaseDataPageState();
}

class _RealtimeDatabaseDataPageState extends State<RealtimeDatabaseDataPage> {
  late DatabaseReference databaseReference;
  StreamSubscription? _subscription;
  final List<Product> _productList = [];
  String orderID = '';

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance
        .reference()
        .child(widget.textInput);
    fetchDataFromRealtimeDatabase();
  }

  void fetchDataFromRealtimeDatabase() {
    _subscription = databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("counter update "+ event.snapshot.value.toString());
        final dynamic data = event.snapshot.value;

        if (data is Map<dynamic, dynamic>) {
          //print("counter data "+ data.toString());
          data.forEach((key, value) {
            print("counter key "+ key.toString());
            Product product = Product.fromMap(key, data);
            _productList.add(product);
          });

        setState(() {});
      } else {
          print('Data is not in the expected format');
        }
      }
    }, onError: (error) {
      print('Error fetching data: $error');
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          Product product = _productList[index];

          return ListTile(
            title: Text('Product Name: ${product.productName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Brand: ${product.brand}'),
                Text('Origin: ${product.origin}'),
                Text('MRP: ${product.mrp}'),
                Text('Color: ${product.color}'),
                Text('Model Number: ${product.modelNumber}'),
                Text('Material: ${product.material}'),
                Text('Manufacturing Date: ${product.manufacturingDate}'),
                Text('Manufacturer: ${product.manufacturer}'),
                Row(
                  children: [
                    const Text('How to Use: '),
                    RichText(
                      text: TextSpan(
                        text: 'Click here',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(product.howToUse);
                          },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Warranty Card: '),
                    RichText(
                      text: TextSpan(
                        text: 'Click here',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(product.warrantyCard);
                          },
                      ),
                    ),
                  ],
                ),
            Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Open the new page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductARViewWidget( arLink: product.arImageLink.toString() )),
                    );
                  },
                  child: const Text('View Product in AR'),
                )
            ),
              ],
            ),
            onTap: () {
              // Handle onTap event
              // You can navigate to a detailed product page or perform any other action
            },
          );
        },
      ),
    );
  }

}

class Product {
  final String productName;
  final String brand;
  final String origin;
  final String mrp;
  final String color;
  final String howToUse;
  final String modelNumber;
  final String warrantyCard;
  final String material;
  final String manufacturingDate;
  final String manufacturer;
  final String arImageLink;

  Product({
    required this.productName,
    required this.brand,
    required this.origin,
    required this.mrp,
    required this.color,
    required this.howToUse,
    required this.modelNumber,
    required this.warrantyCard,
    required this.material,
    required this.manufacturingDate,
    required this.manufacturer,
    required this.arImageLink,
  });

  factory Product.fromMap(String key, Map<dynamic,dynamic> map) {
    return Product(
      productName: map['ProductName'],
      brand: map['Brand'],
      origin: map['Origin'],
      mrp: map['MRP'],
      color: map['Color'],
      howToUse: map['HowToUse'],
      modelNumber: map['ModelNumber'],
      warrantyCard: map['WarrantyCard'],
      material: map['Material'],
      manufacturingDate: map['ManufacturingDate'],
      manufacturer: map['Manufacturer'],
      arImageLink: map['ARImageLink'],
    );
  }
}
