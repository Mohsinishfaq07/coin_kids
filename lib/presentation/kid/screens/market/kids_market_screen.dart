import 'package:coin_kids/presentation/kid/controllers/market_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KidsMarketScreen extends GetView<MarketController> {
  const KidsMarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Market'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value),
                ElevatedButton(
                  onPressed: () => controller.fetchProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text('No products available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Card(
              child: ListTile(
                leading: product.imageUrl.isNotEmpty 
                  ? Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    )
                  : const Icon(Icons.shopping_bag),
                title: Text(product.name),
                subtitle: Text(product.price.toString()),
                trailing: Text('Rating: ${product.rating}'),
              ),
            );
          },
        );
      }),
    );
  }
} 