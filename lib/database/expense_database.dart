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

  /* H E L P E R S */

  /* calculate total expense for each month */
  Future<Map<String, double>> calcMonthlyExpense() async {
    // read db
    await readExpenses();

    // map to keep track of total exp. per month, year
    Map<String, double> monthlyExpense = {};

    // iterate over each expense
    for (var expense in _allEpxpenses) {
      String yearMonth = '${expense.date.year}-${expense.date.month}';

      // if year-monthly totals does not contain month key then set its month key's value to 0
      if (!monthlyExpense.containsKey(yearMonth)) {
        monthlyExpense[yearMonth] = 0;
      }
      // if it is not empty than add it with expense amount
      monthlyExpense[yearMonth] = monthlyExpense[yearMonth]! + expense.amount;
    }

    return monthlyExpense;
  }

  /* calculate total expenses for current month */
  Future<double> calcCurrentMonthTotal() async {
    // read db
    await readExpenses();

    // get current month, year
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;

    // get the expenses for the current month
    List<Expense> currentMonthExpenses = _allEpxpenses.where(
      (expense) {
        return expense.date.month == currentMonth &&
            expense.date.year == currentYear;
      },
    ).toList();

    // sum up the total expense for the current month
    double totalExpense =
        currentMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return totalExpense;
  }

  /* calculate the start month */
  int getStartMonth() {
    // default to current month if there are no expense
    if (_allEpxpenses.isEmpty) {
      return DateTime.now().month;
    }

    // sort expenses by date to show the earliest
    _allEpxpenses.sort((a, b) => a.date.compareTo(b.date));

    return _allEpxpenses.first.date.month;
  }

  /* calculate the start year */
  int getStartYear() {
    // default to current month if there are no expense
    if (_allEpxpenses.isEmpty) {
      return DateTime.now().year;
    }

    // sort expenses by date to show the earliest
    _allEpxpenses.sort((a, b) => a.date.compareTo(b.date));

    return _allEpxpenses.first.date.year;
  }
}
