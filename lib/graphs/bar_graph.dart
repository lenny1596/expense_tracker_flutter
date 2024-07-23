import 'package:expense_tracker_flutter/graphs/each_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlyExpense;
  final int startMonth;

  const MyBarGraph({
    super.key,
    required this.monthlyExpense,
    required this.startMonth,
  });

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  // list of each bar graph data
  List<EachGraph> barData = [];

  // initialize the bar data, use monthly expense to creat list of bars
  void initializeBarData() {
    barData = List.generate(
      widget.monthlyExpense.length,
      (index) => EachGraph(
        x: index,
        y: widget.monthlyExpense[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(minY: 0, maxY: 100),
    );
  }
}
