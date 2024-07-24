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
    // initialize bar data method
    initializeBarData();

    // bar dimensions
    double barWidth = 20;
    double spaceBetweenBars = 15;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width:
            barWidth * barData.length + spaceBetweenBars * (barData.length - 1),
        height: 250,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: 200,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTiles,
                    reservedSize: 25),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            barGroups: barData
                .map(
                  (data) => BarChartGroupData(
                    x: data.x,
                    barRods: [
                      BarChartRodData(
                        toY: data.y,
                        width: 15.0,
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(3),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 200,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTiles(double value, TitleMeta meta) {
  final textStyle = TextStyle(
      color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14);

  String text;
  switch (value.toInt() % 12) {
    case 0:
      text = 'Jan';
      break;
    case 1:
      text = 'Feb';
      break;
    case 2:
      text = 'Mar';
      break;
    case 3:
      text = 'Apr';
      break;
    case 4:
      text = 'May';
      break;
    case 5:
      text = 'Jun';
      break;
    case 6:
      text = 'Jul';
      break;
    case 7:
      text = 'Aug';
      break;
    case 8:
      text = 'Sep';
      break;
    case 9:
      text = 'Oct';
      break;
    case 10:
      text = 'Nov';
      break;
    case 11:
      text = 'Dec';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      text,
      style: textStyle,
    ),
  );
}
