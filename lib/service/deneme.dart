import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'description': doc['description'],
          'createDate': doc['createDate'],
          'count': doc['count'],
          'unit': doc['unit'],
        };
      }).toList();
    } catch (e) {
      print('Error getting products: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products found'));
            } else {
              return Scaffold(
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          var product = snapshot.data![index];
                          return ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                product["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 17),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                  "${"description".tr()} : ${product["description"]}"),
                            ),
                            trailing: Text(
                              "${product["count"]}  ${"quantity".tr()}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 255, 99, 9)),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            onTap: () {},
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}

void main() {
  runApp(MaterialApp(
    home: ProductsPage(),
  ));
}
