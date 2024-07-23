import 'package:expense_tracker_flutter/components/my_list_tile.dart';
import 'package:expense_tracker_flutter/database/expense_database.dart';
import 'package:expense_tracker_flutter/graphs/bar_graph.dart';
import 'package:expense_tracker_flutter/helper/helper.dart';
import 'package:expense_tracker_flutter/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initial state
  @override
  void initState() {
    // read expenses on init start
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();

    // reload graph on init start
    refreshGraphData();
  }

  // graph data futures
  Future<Map<int, double>>? _monthlyExpenseFuture;

  void refreshGraphData() {
    _monthlyExpenseFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calcMonthlyExpense();
  }

  // text controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // add new expense
  void addNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new expense!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Expense",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 10),

            // amount field
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            color: Colors.grey.shade900,
            textColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                // pop the dialog box
                Navigator.pop(context);
                // create an expense
                Expense newExpense = Expense(
                  name: nameController.text,
                  amount: convertStringToDouble(amountController.text),
                  date: DateTime.now(),
                );
                // pass it to db
                await context
                    .read<ExpenseDatabase>()
                    .createNewExpense(newExpense);
                // clear controllers
                nameController.clear();
                amountController.clear();
              }
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            color: Colors.grey.shade900,
            textColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
              amountController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // update expense box
  void updateExpenseBox(Expense expense) {
    // pre-fill existing names and amount
    final existingName = expense.name;
    final existingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit your expense!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: existingName,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 10),

            // amount field
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: existingAmount,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            color: Colors.grey.shade900,
            textColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () async {
              if (nameController.text.isNotEmpty ||
                  amountController.text.isNotEmpty) {
                // pop the dialog box
                Navigator.pop(context);
                // update the expense
                Expense updatedExpense = Expense(
                  name: nameController.text.isNotEmpty
                      ? nameController.text
                      : expense.name,
                  amount: amountController.text.isNotEmpty
                      ? convertStringToDouble(amountController.text)
                      : expense.amount,
                  date: DateTime.now(),
                );
                // get existing expense id
                int existingId = expense.id;
                // pass it to db
                await context
                    .read<ExpenseDatabase>()
                    .updateExpenses(existingId, updatedExpense);
                // clear controllers
                nameController.clear();
                amountController.clear();
              }
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            color: Colors.grey.shade900,
            textColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
              amountController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // delete expense box
  void deleteExpenseBox(int expenseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete this expense?"),
        actions: [
          // delete button
          MaterialButton(
            color: Colors.red.shade700,
            textColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () async {
              // pop the dialog box
              Navigator.pop(context);
              // delete the expense
              await context.read<ExpenseDatabase>().deleteExpense(expenseId);
            },
            child: const Text('Delete'),
          ),

          // cancel button
          MaterialButton(
            color: Colors.grey.shade900,
            textColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      // get dates
      int startMonth = value.getStartMonth();
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;

      // calculate the no. of months since the start month
      int monthCount =
          calculateMonthCount(startMonth, startYear, currentMonth, currentYear);

      // display expenses for current month

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade900,
          elevation: 5,
          onPressed: addNewExpenseBox,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Bar Graph
              SizedBox(
                height: 250,
                child: FutureBuilder(
                  future: _monthlyExpenseFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // check if data is loaded
                      final monthlyExpense = snapshot.data ?? {};
                      // create the list of monthly summary
                      List<double> monthlyExpenseSummary = List.generate(
                        monthCount,
                        (index) => monthlyExpense[startMonth + index] ?? 0.0,
                      );
                      return MyBarGraph(
                          monthlyExpense: monthlyExpenseSummary,
                          startMonth: startMonth);
                    } else {
                      return const Text('Loading...');
                    }
                  },
                ),
              ),

              // List tiles
              Expanded(
                child: ListView.builder(
                  itemCount: value.allExpenses.length,
                  itemBuilder: (context, index) {
                    // return each item in a list tile
                    final eachExpense = value.allExpenses[index];
                    return MyListTile(
                      title: eachExpense.name,
                      trailing: changeFormat(eachExpense.amount),
                      onEdit: (context) => updateExpenseBox(eachExpense),
                      onDelete: (context) => deleteExpenseBox(eachExpense.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
