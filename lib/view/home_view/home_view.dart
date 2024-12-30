import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/color.dart';
import '../product_details_view/productdetailsview.dart';
import 'ProductProvider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts(); // Trigger data fetching
    return Scaffold(
      appBar: AppBar(
        title: Text('Products',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
        backgroundColor:primaryColor,
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.share,color: Colors.white,), // Replace with your desired icon
          ),
        ],

    ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('All Product',style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w800
              ),),
            ),

            SizedBox(height: 15),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (productProvider.error.isNotEmpty) {
                  return Expanded(
                    child: Center(child: Text(productProvider.error)),
                  );
                }

                if (productProvider.products.isEmpty) {
                  return const Expanded(
                    child: Center(child: Text('No products available')),
                  );
                }

                var products = productProvider.products;

                return Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        elevation: 2.0, // Adds shadow for better card appearance
                        child: ListTile(
                          onTap: () {
                            // Navigate to ProductDetailsView when the item is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsView(product: product),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              product['thumbnail'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            product['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '\$${product['price']}',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        )

    );
  }
}
