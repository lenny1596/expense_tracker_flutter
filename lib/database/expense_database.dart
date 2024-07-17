import 'package:expense_tracker_flutter/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _allEpxpenses = [];

  /* S E T U P */

  // initialize db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  /* G E T T E R S */

  List<Expense> get allExpenses => _allEpxpenses;

  /* C R U D - O P E R A T I O N S */
  // Create

  // Read

  // Update

  // Delete

    /* H E L P E R S */
}
