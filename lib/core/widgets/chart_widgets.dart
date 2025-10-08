import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_enums.dart';

class ChartSelector extends StatelessWidget {
  final ChartType selectedChartType;
  final Function(ChartType) onChartTypeChanged;
  final bool isTablet;

  const ChartSelector({
    super.key,
    required this.selectedChartType,
    required this.onChartTypeChanged,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ChartType.values.map((chartType) {
          final isSelected = selectedChartType == chartType;
          return InkWell(
            onTap: () => onChartTypeChanged(chartType),
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 16 : 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    getChartTypeIcon(chartType),
                    size: isTablet ? 20 : 18,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                  ),
                  SizedBox(width: 6),
                  Text(
                    chartTypeToString(chartType),
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomPieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final bool isTablet;

  const CustomPieChart({
    Key? key,
    required this.categoryTotals,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = categoryTotals.entries
        .where((entry) => entry.value > 0)
        .map((entry) => PieChartSectionData(
              color: getCategoryColorByName(entry.key),
              value: entry.value,
              title:
                  '${(entry.value / categoryTotals.values.fold(0.0, (a, b) => a + b) * 100).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: isTablet ? 12 : 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ))
        .toList();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sections: sections.isEmpty
                  ? [
                      PieChartSectionData(
                        color: Colors.grey,
                        value: 1,
                        title: '100%',
                        radius: 50,
                        titleStyle:
                            TextStyle(fontSize: 12, color: Colors.white),
                      )
                    ]
                  : sections,
              centerSpaceRadius: isTablet ? 30 : 20,
              sectionsSpace: 1,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildExpenseLegend(context, categoryTotals, isTablet),
        ),
      ],
    );
  }

  Widget _buildExpenseLegend(
      BuildContext context, Map<String, double> categoryTotals, bool isTablet) {
    if (categoryTotals.isEmpty) {
      return Center(
          child: Text('Không có dữ liệu',
              style: Theme.of(context).textTheme.bodySmall));
    }

    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);
    final validEntries =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: validEntries
            .map((entry) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: getCategoryColorByName(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(categoryToString(entry.key),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: isTablet ? 12 : 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(
                                '${(entry.value / total * 100).toStringAsFixed(1)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: isTablet ? 10 : 9,
                                      color: Colors.grey[600],
                                    )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class CustomTaskPieChart extends StatelessWidget {
  final Map<String, int> categoryTotals;
  final bool isTablet;

  const CustomTaskPieChart(
      {Key? key, required this.categoryTotals, this.isTablet = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = categoryTotals.entries
        .where((entry) => entry.value > 0)
        .map((entry) => PieChartSectionData(
              color: getCategoryColorByName(entry.key),
              value: entry.value.toDouble(),
              title:
                  '${(entry.value / categoryTotals.values.fold(0, (a, b) => a + b) * 100).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ))
        .toList();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(PieChartData(
              sections: sections.isEmpty
                  ? [
                      PieChartSectionData(
                          color: Colors.grey,
                          value: 1,
                          title: '100%',
                          radius: 50,
                          titleStyle:
                              TextStyle(fontSize: 12, color: Colors.white))
                    ]
                  : sections,
              centerSpaceRadius: isTablet ? 30 : 20,
              sectionsSpace: 1)),
        ),
        SizedBox(width: 16),
        Expanded(
            flex: 2,
            child: _buildTaskLegend(context, categoryTotals, isTablet)),
      ],
    );
  }

  Widget _buildTaskLegend(
      BuildContext context, Map<String, int> categoryTotals, bool isTablet) {
    if (categoryTotals.isEmpty) {
      return Center(
          child: Text('Không có dữ liệu',
              style: Theme.of(context).textTheme.bodySmall));
    }

    final total = categoryTotals.values.fold(0, (a, b) => a + b);
    final validEntries =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: validEntries
            .map((entry) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            color: getCategoryColorByName(entry.key),
                            shape: BoxShape.circle)),
                    SizedBox(width: 8),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(categoryToString(entry.key),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: isTablet ? 12 : 10,
                                      fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              '${(entry.value / total * 100).toStringAsFixed(1)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: isTablet ? 10 : 9,
                                      color: Colors.grey[600])),
                        ])),
                  ]),
                ))
            .toList(),
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final bool isTablet;

  const CustomBarChart(
      {Key? key, required this.categoryTotals, this.isTablet = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return Center(
          child: Text('Không có dữ liệu',
              style: Theme.of(context).textTheme.bodyMedium));
    }

    final entries =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();
    final maxValue =
        entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue * 1.2,
        barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final category = entries[group.x.toInt()].key;
          final value = entries[group.x.toInt()].value;
          return BarTooltipItem(
              '${categoryToString(category)}\n${value.toStringAsFixed(0)}',
              TextStyle(color: Colors.white, fontSize: 12));
        })),
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: isTablet ? 10 : 8)))),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < entries.length) {
                        return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                                categoryToString(entries[value.toInt()].key),
                                style: TextStyle(fontSize: isTablet ? 10 : 8),
                                maxLines: 2,
                                textAlign: TextAlign.center));
                      }
                      return Text('');
                    })),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue / 5),
        borderData: FlBorderData(show: false),
        barGroups: entries
            .asMap()
            .entries
            .map((entry) => BarChartGroupData(x: entry.key, barRods: [
                  BarChartRodData(
                      toY: entry.value.value,
                      color: getCategoryColorByName(entry.value.key),
                      width: isTablet ? 20 : 16,
                      borderRadius: BorderRadius.circular(4))
                ]))
            .toList()));
  }
}

class CustomTaskBarChart extends StatelessWidget {
  final Map<String, int> categoryTotals;
  final bool isTablet;

  const CustomTaskBarChart(
      {Key? key, required this.categoryTotals, this.isTablet = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return Center(
          child: Text('Không có dữ liệu',
              style: Theme.of(context).textTheme.bodyMedium));
    }

    final entries =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();
    final maxValue =
        entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue * 1.2,
        barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final category = entries[group.x.toInt()].key;
          final value = entries[group.x.toInt()].value;
          return BarTooltipItem('${categoryToString(category)}\n$value',
              TextStyle(color: Colors.white, fontSize: 12));
        })),
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: isTablet ? 10 : 8)))),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < entries.length) {
                        return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                                categoryToString(entries[value.toInt()].key),
                                style: TextStyle(fontSize: isTablet ? 10 : 8),
                                maxLines: 2,
                                textAlign: TextAlign.center));
                      }
                      return Text('');
                    })),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue / 5),
        borderData: FlBorderData(show: false),
        barGroups: entries
            .asMap()
            .entries
            .map((entry) => BarChartGroupData(x: entry.key, barRods: [
                  BarChartRodData(
                      toY: entry.value.value.toDouble(),
                      color: getCategoryColorByName(entry.value.key),
                      width: isTablet ? 20 : 16,
                      borderRadius: BorderRadius.circular(4))
                ]))
            .toList()));
  }
}

class CustomLineChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final bool isTablet;

  const CustomLineChart(
      {Key? key, required this.categoryTotals, this.isTablet = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return Center(
          child: Text('Không có dữ liệu',
              style: Theme.of(context).textTheme.bodyMedium));
    }

    final entries =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();
    final maxValue =
        entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final spots = entries
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList();

    return LineChart(LineChartData(
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                      final category = entries[spot.x.toInt()].key;
                      final value = entries[spot.x.toInt()].value;
                      return LineTooltipItem(
                          '${categoryToString(category)}\n${value.toStringAsFixed(0)}',
                          TextStyle(color: Colors.white, fontSize: 12));
                    }).toList())),
        gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue / 5),
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: isTablet ? 10 : 8)))),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < entries.length) {
                        return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                                categoryToString(entries[value.toInt()].key),
                                style: TextStyle(fontSize: isTablet ? 10 : 8),
                                maxLines: 2,
                                textAlign: TextAlign.center));
                      }
                      return Text('');
                    })),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (entries.length - 1).toDouble(),
        minY: 0,
        maxY: maxValue * 1.2,
        lineBarsData: [
          LineChartBarData(
              spots: spots,
              color: Theme.of(context).primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                          radius: 6,
                          color: getCategoryColorByName(
                              entries[spot.x.toInt()].key),
                          strokeColor: Colors.white,
                          strokeWidth: 2)),
              belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).primaryColor.withOpacity(0.3)))
        ]));
  }
}

class CustomTaskLineChart extends StatelessWidget {
  final Map<String, int> categoryTotals;
  final bool isTablet;

  const CustomTaskLineChart(
      {Key? key, required this.categoryTotals, this.isTablet = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return Center(
          child: Text('Không có dữ liệu',
              style: Theme.of(context).textTheme.bodyMedium));
    }

    final entries =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();
    final maxValue =
        entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final spots = entries
        .asMap()
        .entries
        .map((entry) =>
            FlSpot(entry.key.toDouble(), entry.value.value.toDouble()))
        .toList();

    return LineChart(LineChartData(
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                      final category = entries[spot.x.toInt()].key;
                      final value = entries[spot.x.toInt()].value;
                      return LineTooltipItem(
                          '${categoryToString(category)}\n$value',
                          TextStyle(color: Colors.white, fontSize: 12));
                    }).toList())),
        gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue / 5),
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: isTablet ? 10 : 8)))),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < entries.length) {
                        return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                                categoryToString(entries[value.toInt()].key),
                                style: TextStyle(fontSize: isTablet ? 10 : 8),
                                maxLines: 2,
                                textAlign: TextAlign.center));
                      }
                      return Text('');
                    })),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (entries.length - 1).toDouble(),
        minY: 0,
        maxY: maxValue * 1.2,
        lineBarsData: [
          LineChartBarData(
              spots: spots,
              color: Theme.of(context).primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                          radius: 6,
                          color: getCategoryColorByName(
                              entries[spot.x.toInt()].key),
                          strokeColor: Colors.white,
                          strokeWidth: 2)),
              belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).primaryColor.withOpacity(0.3)))
        ]));
  }
}
