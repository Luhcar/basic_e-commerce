import 'dart:io';
import 'package:ecommerce/pembeli/cart.dart';
import 'package:ecommerce/database_helper.dart';
import 'package:ecommerce/pembeli/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FilterSortingPage extends StatefulWidget {
  @override
  _FilterSortingPageState createState() => _FilterSortingPageState();
}

class _FilterSortingPageState extends State<FilterSortingPage> {
  String? selectedSorting;
  final List<String> sortingOptions = [
    'Name (A-Z)',
    'Name (Z-A)',
    'Price (High-Low)',
    'Price (Low-High)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter & Sorting'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Sorting'),
          ),
          ...sortingOptions.map((option) => RadioListTile(
                title: Text(option),
                value: option,
                groupValue: selectedSorting,
                onChanged: (value) {
                  setState(() {
                    selectedSorting = value as String;
                  });
                },
              )),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => setState(() {
                  selectedSorting = null;
                }),
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Apply sorting logic here
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}