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

  // Create - Add a new expense
  Future<void> createNewExpense(Expense newExpense) async {
    await isar.writeTxn(
      () => isar.expenses.put(newExpense),
    );

    // re-render all expenses
    await readExpenses();
  }

  // Read - All existing expense
  Future<void> readExpenses() async {
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // send fetched expenses to local list
    _allEpxpenses.clear();
    _allEpxpenses.addAll(fetchedExpenses);

    // update UI
    notifyListeners();
  }

  // Update - update an expense
  Future<void> updateExpenses(int id, Expense updatedExpense) async {
    // check if new expense id matches existing one's
    updatedExpense.id = id;

    await isar.writeTxn(
      () => isar.expenses.put(updatedExpense),
    );

    // re-render all expenses
    await readExpenses();
  }

  // Delete - delete an expense
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(
      () => isar.expenses.delete(id),
    );

    // re-render all expenses
    await readExpenses();
  }
}
