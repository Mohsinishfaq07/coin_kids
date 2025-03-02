import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coin_kids/core/utils/landscape_orientation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsScreen extends StatelessWidget {
  final MarketProductModel product;
  final GoalService _goalService = Get.find<GoalService>();
  final verticalNavBarController = Get.find<VerticalNavBarController>();

  ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  Future<void> _addToGoals() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Add market product as goal and get DocumentReference
      final DocumentReference<Map<String, dynamic>> docRef =
          await _goalService.addMarketProductAsGoal(product);

      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Set the navigation to goals tab (index 1)
      verticalNavBarController.currentItem.value = 1;

      // Navigate back to KidHomeScreen
      Get.offAll(
        () => KidHomeScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );

      Get.snackbar(
        'Success',
        'Added to your goals!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();
    // KidGoalsController kidGoalsController = Get.put(KidGoalsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Left side - Product Image
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.error_outline,
                            size: 100,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          // Right side - Product Details
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      'Price',
                      product.formattedPrice,
                      Icons.attach_money,
                      Colors.green,
                    ),
                    _buildInfoRow(
                      context,
                      'Rating',
                      '${product.ratingStars} (${product.rating.toStringAsFixed(1)})',
                      Icons.star,
                      Colors.orange,
                    ),
                    _buildInfoRow(
                      context,
                      'Age Range',
                      '${product.minAge} - ${product.maxAge} years',
                      Icons.person_outline,
                      Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.about
                          .map((description) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '• $description',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _addToGoals,
                            icon: const Icon(Icons.flag),
                            label: const Text(
                              'Add to Goals',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.snackbar(
                                'Coming Soon',
                                'Purchase functionality will be available soon!',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text(
                              'Purchase Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
