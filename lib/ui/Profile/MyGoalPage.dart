import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/child/child_bloc.dart';
import '../../bloc/child/child_state.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/database_food.dart';
import '../../database/database_meal.dart';

import '../../model/Meal.dart';

// Tambahkan konstanta untuk style yang sering digunakan
const _kDefaultPadding = EdgeInsets.all(16.0);
const _kDefaultBorderRadius = 24.0;
const _kDefaultIconSize = 20.0;
const _kDefaultSpacing = 16.0;

// Tambahkan extension untuk memudahkan penggunaan shadow
extension BoxDecorationX on BoxDecoration {
  static BoxDecoration get defaultShadow => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kDefaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );
}

// Tambahkan fungsi helper terpisah
BoxDecoration gradientContainer({
  required List<Color> colors,
  double borderRadius = _kDefaultBorderRadius,
}) =>
    BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );

// Tambahkan extension untuk style text yang sering digunakan
extension TextStyleX on TextStyle {
  static const defaultTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: Colors.black87,
  );

  static const smallLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
}

class MyGoalPage extends StatefulWidget {
  const MyGoalPage({super.key});

  @override
  State<MyGoalPage> createState() => _MyGoalPageState();
}

class _MyGoalPageState extends State<MyGoalPage> {
  final FoodSqflite _foodDb = FoodSqflite();
  final MealSqflite _mealDb = MealSqflite();

  // Pindahkan fungsi helper ke class terpisah jika digunakan di banyak tempat
  static const _chartHeight = 200.0;
  static const _lineChartHeight = 250.0;

  // Sederhanakan fungsi untuk mendapatkan data chart
  Future<Map<String, double>> _getNutritionData(String childId) async {
    final date = DateTime.now();
    final meals = await _mealDb.getMealsByDate(
        childId, "${date.year}/${date.month}/${date.day}");

    return _calculateNutrition(meals);
  }

  Future<Map<String, double>> _calculateNutrition(List<Meal> meals) async {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var meal in meals) {
      final foods = await _foodDb.getFoodbyId(meal.foodId);
      if (foods.isNotEmpty) {
        final food = foods.first;
        final qty = meal.qty;
        totalCalories += (food.calories * qty);
        totalProtein += (food.protein * qty);
        totalCarbs += (food.carbs * qty);
        totalFat += (food.fat * qty);
      }
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }

  Future<List<Map<String, dynamic>>> _getNutritionHistory(
      String childId) async {
    List<Map<String, dynamic>> history = [];
    final now = DateTime.now();

    // Mendapatkan tanggal 7 hari yang lalu
    final startDate = now.subtract(
        const Duration(days: 6)); // 6 hari yang lalu + hari ini = 7 hari

    for (int i = 0; i <= 6; i++) {
      final date = startDate.add(Duration(days: i));
      final dateString = "${date.year}/${date.month}/${date.day}";
      final meals = await _mealDb.getMealsByDate(childId, dateString);

      double totalCalories = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFat = 0;

      for (Meal meal in meals) {
        final foods = await _foodDb.getFoodbyId(meal.foodId);
        if (foods.isNotEmpty) {
          final food = foods.first;
          final qty = meal.qty;
          totalCalories += (food.calories * qty);
          totalProtein += (food.protein * qty);
          totalCarbs += (food.carbs * qty);
          totalFat += (food.fat * qty);
        }
      }

      history.add({
        'date': date,
        'dateString': dateString,
        'nutrition': {
          'calories': totalCalories,
          'protein': totalProtein,
          'carbs': totalCarbs,
          'fat': totalFat,
        }
      });
    }

    return history;
  }

  Widget _buildNutritionChart(Map<String, double> nutrition) {
    double maxNutrition = [
      nutrition['protein'] ?? 0,
      nutrition['carbs'] ?? 0,
      nutrition['fat'] ?? 0,
    ].reduce((curr, next) => curr > next ? curr : next);

    double maxY = maxNutrition + (maxNutrition * 0.2);
    maxY = maxY < 100 ? 100 : maxY;
    int interval = (maxY / 5).ceil();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.black87,
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String nutrientValue = '';
                Color tooltipColor = Colors.white;
                switch (group.x) {
                  case 0:
                    nutrientValue =
                        '${nutrition['protein']?.toStringAsFixed(1)} g';
                    tooltipColor = Colors.blue;
                    break;
                  case 1:
                    nutrientValue =
                        '${nutrition['carbs']?.toStringAsFixed(1)} g';
                    tooltipColor = Colors.green;
                    break;
                  case 2:
                    nutrientValue = '${nutrition['fat']?.toStringAsFixed(1)} g';
                    tooltipColor = Colors.red;
                    break;
                }
                return BarTooltipItem(
                  nutrientValue,
                  TextStyle(
                    color: tooltipColor,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: nutrition['protein'] ?? 0,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.blue.shade500],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: BorderRadius.circular(8),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: nutrition['carbs'] ?? 0,
                  gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.green.shade500],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: BorderRadius.circular(8),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: nutrition['fat'] ?? 0,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade300, Colors.red.shade500],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: BorderRadius.circular(8),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text(
                        'Protein',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      );
                    case 1:
                      return const Text(
                        'Carbs',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      );
                    case 2:
                      return const Text(
                        'Fat',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      );
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'gram',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 46,
                interval: interval.toDouble(),
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${value.toInt()}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval.toDouble(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildCaloriesChart(double calories) {
    double maxY = calories + (calories * 0.2);
    maxY = maxY < 1000 ? 1000 : maxY;
    int interval = (maxY / 5).ceil();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.black87,
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${calories.toStringAsFixed(1)} kcal',
                  TextStyle(
                    color: Colors.orange.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: calories,
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade300,
                      Colors.orange.shade500,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 40,
                  borderRadius: BorderRadius.circular(8),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return const Text(
                    'Calories',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'kcal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 46,
                interval: interval.toDouble(),
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${value.toInt()}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval.toDouble(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildNutritionLineChart(List<Map<String, dynamic>> history) {
    // Mencari nilai maksimum untuk skala Y
    double maxValue = 0;
    for (var day in history) {
      final nutrition = day['nutrition'] as Map<String, double>;
      final values = [
        nutrition['protein'] ?? 0,
        nutrition['carbs'] ?? 0,
        nutrition['fat'] ?? 0,
      ];
      final dayMax = values.reduce((curr, next) => curr > next ? curr : next);
      if (dayMax > maxValue) maxValue = dayMax;
    }

    // Menambahkan margin 20% ke atas
    double maxY = maxValue + (maxValue * 0.2);
    maxY = maxY < 100 ? 100 : maxY;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < history.length) {
                    final date = history[value.toInt()]['date'] as DateTime;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${date.day}/${date.month}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'gram',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              axisNameSize: 16,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: maxY / 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // Protein Line
            LineChartBarData(
              spots: List.generate(history.length, (index) {
                final nutrition =
                    history[index]['nutrition'] as Map<String, double>;
                return FlSpot(
                  index.toDouble(),
                  nutrition['protein'] ?? 0,
                );
              }),
              isCurved: true,
              curveSmoothness: 0.3,
              preventCurveOverShooting: true,
              color: Colors.red,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.red,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.1),
              ),
            ),
            // Carbs Line
            LineChartBarData(
              spots: List.generate(history.length, (index) {
                final nutrition =
                    history[index]['nutrition'] as Map<String, double>;
                return FlSpot(
                  index.toDouble(),
                  nutrition['carbs'] ?? 0,
                );
              }),
              isCurved: true,
              curveSmoothness: 0.3,
              preventCurveOverShooting: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.blue,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
            // Fat Line
            LineChartBarData(
              spots: List.generate(history.length, (index) {
                final nutrition =
                    history[index]['nutrition'] as Map<String, double>;
                return FlSpot(
                  index.toDouble(),
                  nutrition['fat'] ?? 0,
                );
              }),
              isCurved: true,
              curveSmoothness: 0.3,
              preventCurveOverShooting: true,
              color: Colors.green,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.green,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
          ],
          minX: 0,
          maxX: history.length - 1.0,
          minY: 0,
          maxY: maxY,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black87,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                final date =
                    history[touchedSpots.first.x.toInt()]['date'] as DateTime;
                String day = date.day.toString().padLeft(2, '0');
                String month = date.month.toString().padLeft(2, '0');
                String dateStr = '\n${day}/${month}/${date.year}';

                return touchedSpots.map((LineBarSpot spot) {
                  Color color;

                  switch (spot.barIndex) {
                    case 0:
                      color = Colors.red;
                      break;
                    case 1:
                      color = Colors.blue;
                      break;
                    case 2:
                      color = Colors.green;
                      break;
                    default:
                      color = Colors.white;
                  }

                  bool isLastItem = spot == touchedSpots.last;

                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)}g',
                    TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                    children: isLastItem
                        ? [
                            TextSpan(
                              text: dateStr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        : null,
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaloriesLineChart(List<Map<String, dynamic>> history) {
    // Mencari nilai maksimum untuk skala Y
    double maxValue = 0;
    for (var day in history) {
      final nutrition = day['nutrition'] as Map<String, double>;
      final calories = nutrition['calories'] ?? 0;
      if (calories > maxValue) maxValue = calories;
    }

    // Menambahkan margin 20% ke atas
    double maxY = maxValue + (maxValue * 0.2);
    maxY = maxY < 1000 ? 1000 : maxY;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < history.length) {
                    final date = history[value.toInt()]['date'] as DateTime;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${date.day}/${date.month}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'kcal',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              axisNameSize: 16,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: maxY / 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(history.length, (index) {
                final nutrition =
                    history[index]['nutrition'] as Map<String, double>;
                return FlSpot(
                  index.toDouble(),
                  nutrition['calories'] ?? 0,
                );
              }),
              isCurved: true,
              curveSmoothness: 0.3,
              preventCurveOverShooting: true,
              color: Colors.orange,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.orange,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.orange.withOpacity(0.1),
              ),
            ),
          ],
          minX: 0,
          maxX: history.length - 1.0,
          minY: 0,
          maxY: maxY,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black87,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                final date =
                    history[touchedSpots.first.x.toInt()]['date'] as DateTime;
                String day = date.day.toString().padLeft(2, '0');
                String month = date.month.toString().padLeft(2, '0');
                String dateStr = '\n${day}/${month}/${date.year}';

                return touchedSpots.map((LineBarSpot spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)} kcal',
                    const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: dateStr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _getGenderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Colors.blue;
      case 'female':
        return Colors.pink;
      default:
        return Colors.purple;
    }
  }

  // Tambahkan method untuk menghitung BMI
  double _calculateBMI(double weight, double height) {
    // BMI = weight(kg) / (height(m))²
    double heightInMeter = height / 100;
    return weight / (heightInMeter * heightInMeter);
  }

  // Update method untuk mendapatkan kategori BMI dengan informasi tambahan
  Map<String, dynamic> _getBMIInfo(double bmi) {
    if (bmi < 18.5) {
      return {
        'category': 'Underweight',
        'color': Colors.blue,
        'description': 'Below ideal weight',
        'icon': Icons.arrow_downward,
      };
    } else if (bmi >= 18.5 && bmi < 25) {
      return {
        'category': 'Normal',
        'color': Colors.green,
        'description': 'Ideal weight',
        'icon': Icons.check_circle,
      };
    } else if (bmi >= 25 && bmi < 30) {
      return {
        'category': 'Overweight',
        'color': Colors.orange,
        'description': 'Above ideal weight',
        'icon': Icons.warning,
      };
    } else {
      return {
        'category': 'Obese',
        'color': Colors.red,
        'description': 'Far above ideal weight',
        'icon': Icons.warning,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildBloc, ChildState>(
      builder: (context, state) {
        if (state is LoadChildState) {
          final Color genderColor = _getGenderColor(state.child.gender);
          final double bmi = _calculateBMI(
            state.child.weight,
            state.child.height,
          );
          final Map<String, dynamic> bmiInfo = _getBMIInfo(bmi);

          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'My Goal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade300,
                                Colors.orange.shade100,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.flag_rounded,
                                  color: Colors.orange.shade400,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Goal',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      state.child.goal,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        letterSpacing: 0.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        _buildSectionContainer(
                          title: 'Details',
                          showIcon: false,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      bmiInfo['color'].withOpacity(0.15),
                                      bmiInfo['color'].withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: bmiInfo['color'].withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'BMI',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                bmiInfo['description'],
                                                style: TextStyle(
                                                  color: bmiInfo['color'],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: bmiInfo['color'].withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                bmiInfo['icon'],
                                                color: bmiInfo['color'],
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                bmiInfo['category'],
                                                style: TextStyle(
                                                  color: bmiInfo['color'],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      bmi.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: bmiInfo['color'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildGoalDetail(
                                'Current weight',
                                '${state.child.weight} kg',
                                Icons.monitor_weight_outlined,
                                genderColor,
                              ),
                              _buildGoalDetail(
                                'Current height',
                                '${state.child.height} cm',
                                Icons.height_outlined,
                                genderColor,
                              ),
                              _buildGoalDetail(
                                'Age',
                                '${state.child.age} years',
                                Icons.cake_outlined,
                                genderColor,
                              ),
                              _buildGoalDetail(
                                'Gender',
                                state.child.gender,
                                Icons.person_outline,
                                genderColor,
                              ),
                            ],
                          ),
                        ),
                        _buildSectionContainer(
                          title: 'Today\'s Nutrition',
                          icon: Icons.show_chart,
                          iconColor: Colors.blue,
                          child: FutureBuilder<Map<String, double>>(
                            future: _getNutritionData(state.child.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    _buildCaloriesChart(
                                        snapshot.data!['calories'] ?? 0),
                                    const SizedBox(height: 16),
                                    _buildNutritionChart(snapshot.data!),
                                  ],
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        _buildSectionContainer(
                          title: 'Calories Progress (7 Days)',
                          icon: Icons.bar_chart,
                          iconColor: Colors.orange,
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: _getNutritionHistory(state.child.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return _buildCaloriesLineChart(snapshot.data!);
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        _buildSectionContainer(
                          title: 'Nutrition Progress (7 Days)',
                          icon: Icons.show_chart,
                          iconColor: Colors.green,
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: _getNutritionHistory(state.child.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    _buildNutritionLineChart(snapshot.data!),
                                    const SizedBox(height: 16),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _buildLegendItem(
                                              'Protein', Colors.red),
                                          const SizedBox(width: 16),
                                          _buildLegendItem(
                                              'Carbs', Colors.blue),
                                          const SizedBox(width: 16),
                                          _buildLegendItem('Fat', Colors.green),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildGoalDetail(
      String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    IconData? icon,
    Color? iconColor,
    required Widget child,
    bool showIcon = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: _kDefaultPadding,
      decoration: BoxDecorationX.defaultShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon && icon != null) ...[
            _buildSectionHeader(title: title, icon: icon, iconColor: iconColor),
            const SizedBox(height: _kDefaultSpacing),
          ] else
            Text(
              title,
              style: TextStyleX.defaultTitle.copyWith(
                fontSize: title.contains('Progress') ? 14 : 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: _kDefaultSpacing),
          child,
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: gradientContainer(
            colors: [
              iconColor?.withOpacity(0.2) ?? Colors.grey.shade200,
              iconColor?.withOpacity(0.1) ?? Colors.grey.shade100,
            ],
            borderRadius: 14,
          ),
          child: Icon(
            icon,
            color: iconColor ?? Colors.grey,
            size: _kDefaultIconSize,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyleX.defaultTitle.copyWith(
              fontSize: title.contains('Progress') ? 14 : 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
