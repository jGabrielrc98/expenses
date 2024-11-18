import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/transaction.dart';
import 'char_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactions {
    // Definir o primeiro dia da semana como segunda-feira
    final now = DateTime.now();
    final startOfWeek = now.subtract(
        Duration(days: now.weekday - 1)); // Segunda-feira da semana atual

    return List.generate(7, (index) {
      final weekDay = startOfWeek
          .add(Duration(days: index)); // Incrementa os dias da semana

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'value': totalSum,
      };
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                value: (tr['value'] is double)
                    ? tr['value'] as double
                    : 0.0, // Verificação de tipo,
                percentage: (_weekTotalValue > 0.0)
                    ? (tr['value'] as double) / _weekTotalValue
                    : 0.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
