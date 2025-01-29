 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddMoneyController extends GetxController {
  RxDouble spendingAmount = 0.0.obs; // Changed to RxDouble
  RxDouble savingAmount = 0.0.obs; // Changed to RxDouble
  RxDouble totalValue = 0.0.obs; // Changed to RxDouble
  var clickedIndex = 0.obs; // Observable for the text
  RxBool isJarFilled = false.obs;
  RxList<double> droppedNotes = <double>[].obs; // Changed to double
  RxString spendingJarColor = ''.obs;
  RxString savingJarColor = ''.obs;
  // var droppedNotes = <int>[].obs;
  // @override
  // void onInit() {
  //   super.onInit();
  //    //fetchSpendingAmount();
  //   // fetchSavingAmount();
  //   // fetchSavingsColor();
  //   // fetchSpendingColor();
  //   // Call this method to fetch the spending amount when the controller is initialized
  // }

 
  Future<void> fetchSpendingColor() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final colorString =
            data['spendings']?['color'] ?? "#000000"; // Default black color

         spendingJarColor.value = colorString;
        print('Updated spendingColor: ${spendingJarColor.value}');
      } else {
        print('No document found for the given parentId');
        spendingJarColor.value = "#000000"; // Default black color
      }
    } catch (e) {
      print('Error fetching spending color: $e');
      spendingJarColor.value = "#000000"; // Default black color
    }
  }

  void onNoteDropped(String noteAsset) {
    try {
      // Extract numeric value from the asset name using regular expression
      final noteValueString = noteAsset.split('/').last.split('.').first;
      final noteValue =
          double.parse(RegExp(r'\d+').stringMatch(noteValueString)!);

      droppedNotes.add(noteValue);

      // Update the total value
      totalValue.value =
          droppedNotes.fold(0.0, (sum, value) => sum + value); // Changed to 0.0
    } catch (e) {
      print("Error parsing note asset: $e");
    }
  }

  void resetJar() {
    droppedNotes.clear();
    totalValue.value = 0.0; // Reset to 0.0
  }

  Future<void> fetchSpendingAmount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        print('Fetched data: $data');

        final amount = data['spendings']?['amount'] ?? 0.0;
        spendingAmount.value = amount.toDouble(); // Converted to double
        print('Updated spendingAmount: ${spendingAmount.value}');
      } else {
        print('No document found for the given parentId');
        spendingAmount.value = 0.0; // Default to 0.0
      }
    } catch (e) {
      print('Error fetching spending amount: $e');
      spendingAmount.value = 0.0; // Default to 0.0
    }
  }

  Future<void> fetchSavingAmount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        print('Fetched data: $data');

        final dynamic amount = data['savings']?['amount'];
        print('Raw amount value: $amount (${amount.runtimeType})');

        if (amount != null) {
          if (amount is String) {
            final sanitizedAmount = amount.trim();
            if (sanitizedAmount.isEmpty) {
              print('Empty amount string.');
              savingAmount.value = 0.0;
            } else if (RegExp(r'^\d+(\.\d+)?$').hasMatch(sanitizedAmount)) {
              savingAmount.value = double.parse(sanitizedAmount);
            } else {
              print('Invalid amount format: "$sanitizedAmount"');
              savingAmount.value = 0.0;
            }
          } else if (amount is int || amount is double) {
            savingAmount.value = amount.toDouble(); // Converted to double
          } else {
            print('Unsupported type for amount: $amount');
            savingAmount.value = 0.0;
          }
        } else {
          print('No savings.amount found in the document.');
          savingAmount.value = 0.0;
        }

        print('Updated savingAmount: ${savingAmount.value}');
      } else {
        print('No document found for the given parentId.');
        savingAmount.value = 0.00;
      }
    } catch (e) {
      print('Error fetching saving amount: $e');
      savingAmount.value = 0.0;
    }
  }

  void undoLastDrop() {
    if (droppedNotes.isNotEmpty) {
      droppedNotes.removeLast(); // Remove the last note from the list

      // Recalculate the total value
      totalValue.value =
          droppedNotes.fold(0.0, (sum, value) => sum + value); // Changed to 0.0
    }
  }

  final Map<String, double> notesMap = {
    "assets/5.png": 5.0,
    "assets/10.png": 10.0,
    "assets/20.png": 20.0,
    "assets/50.png": 50.0,
    "assets/100.png": 100.0,
    "assets/200.png": 200.0,
  };

  final Map<String, double> firstCoinList = {
    "assets/1euro.png": 1.0,
    "assets/2euros.png": 2.0,
  };

  final Map<String, double> secondCoinList = {
    "assets/50cent.png": 0.5,
    "assets/20cents.png": 0.2,
    "assets/10cents.png": 0.1,
  };

  final Map<String, double> thirdCoinList = {
    "assets/5cents.png": 0.05,
    "assets/2cents.png": 0.02,
    "assets/1cents.png": 0.01,
  };

  Future<void> fetchSavingsColor() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final colorString =
            data['savings']?['color'] ?? "#000000"; // Default black color

        savingJarColor.value = colorString; // Convert and store
        print('Updated spendingColor: ${savingJarColor.value}');
      } else {
        print('No document found for the given parentId');
        savingJarColor.value = "#000000"; // Default black color
      }
    } catch (e) {
      print('Error fetching spending color: $e');
      savingJarColor.value = "#000000"; // Default black color
    }
  }
}
