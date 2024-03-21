import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:task_flutter/profile_page.dart'; // Import the profile page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All'; // Default selected category
  List<dynamic> _products = []; // List to store products
  bool _isLoading = true; // Track if data is loading

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when HomePage is initialized
  }

  Future<void> _fetchProducts({String? category}) async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    String apiUrl = 'https://fakestoreapi.com/products';
    if (category != null && category != 'All') {
      apiUrl += '/category/$category';
    }
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        _products = jsonDecode(response.body);
        _isLoading = false; // Set loading state to false when data is fetched
      });
    } else {
      setState(() {
        _isLoading = false; // Set loading state to false on error
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to fetch products. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: const Text(
          'Home',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          // Replace the IconButton with a TextButton
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage()), // Navigate to the profile page
                );
              },
              child: Icon(Icons.person, color: Colors.white, size: 25)),
        ],
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while data is loading
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(64, 75, 96, .9),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    value: _selectedCategory,
                    items: _buildCategoryItems(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value
                            as String; // Ensure the value is cast to String
                      });
                      _fetchProducts(category: _selectedCategory);
                    },
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: _products.isEmpty
                      ? Center(
                          child: Text(
                              'No products found')) // Show message if no products available
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Color.fromRGBO(64, 75, 96, .9),
                              elevation: 4,
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white24,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    _products[index]['title'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      '\$${_products[index]['price']}',
                                      style: TextStyle(color: Colors.white)),
                                  // Add more product details as needed
                                  trailing: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                  )),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  List<DropdownMenuItem<String>> _buildCategoryItems() {
    Set<String> categories = {'All'};
    for (var product in _products) {
      categories.add(product['category']);
    }
    return categories.map((String category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Text(category),
      );
    }).toList();
  }
}
