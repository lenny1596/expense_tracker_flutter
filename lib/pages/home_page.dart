import 'package:expense_tracker_flutter/database/expense_database.dart';
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
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();
  }

  // text controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // open dialogbox to add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Expense!"),
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
            color: Colors.grey[900],
            textColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                // pop the dialog
                Navigator.pop(context);
                // create an expense
                Expense newExpense = Expense(
                  name: nameController.text,
                  amount: convertStringToDouble(amountController.text),
                  date: DateTime.now(),
                );
                // pass it to db
                context.read<ExpenseDatabase>().createNewExpense(newExpense);
                // clear controllers
                nameController.clear();
                amountController.clear();
              }
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
              color: Colors.grey[900],
              textColor: Colors.white,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                Navigator.pop(context);
                nameController.clear();
                amountController.clear();
              },
              child: const Text("Cancel")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[900],
          elevation: 5,
          onPressed: addNewExpense,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
