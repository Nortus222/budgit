// ignore_for_file: file_names

import 'package:budgit/db/model/transaction.dart';
import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key}) : super(key: key);

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final heightMultiplier = SizeConfig.heightMultiplier!;

    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: 35 * heightMultiplier,
      child: Card(
        color: AppColors.white,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<List<TransactionBudgit>>(
                future: model.list,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        LocaleKeys.no_transactions_yet.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.grey),
                      ));
                    } else {
                      return BarChart(mainBarData(snapshot.data ?? []));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double sum, {
    bool isTouched = false,
    Color barColor = AppColors.yellow,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? sum : 0.9 * sum,
          color: isTouched ? AppColors.redChart : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 1.3 * sum,
            color: AppColors.white,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<TransactionBudgit> list) {
    List<BarChartGroupData> barList = [];

    int count = 7;
    double sumPerDay = 0;

    for (int i = 0; i < 7; i++) {
      sumPerDay = 0;
      for (var element in list) {
        if (element.transaction_time.day == (DateTime.now().day - i)) {
          sumPerDay += element.amount;
        }
      }

      barList.add(
          makeGroupData(count--, sumPerDay, isTouched: count == touchedIndex));
    }

    return barList.reversed.toList();
  }

  BarChartData mainBarData(List<TransactionBudgit> list) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => AppColors.green,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              DateTime date = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - (7 - group.x.toInt()),
              );
              String weekDay = DateFormat('EEEE').format(date);

              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              DateTime date = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - (7 - value.toInt()),
              );
              String weekDay = DateFormat('E').format(date);
              return SideTitleWidget(
                meta: meta,
                space: 4,
                child: Text(
                  weekDay,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(list),
      gridData: FlGridData(show: false),
    );
  }
}
