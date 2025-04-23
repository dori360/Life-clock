import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: const LifeClockPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LifeClockPage extends StatefulWidget {
  const LifeClockPage({Key? key}) : super(key: key);

  @override
  State<LifeClockPage> createState() => _LifeClockPageState();
}

class _LifeClockPageState extends State<LifeClockPage> {
  DateTime? birthDate;
  DateTime currentTime = DateTime.now();
  Timer? timer;
  
  // Default life expectancy (in years)
  final double lifeExpectancy = 80.0;
  
  // Hours of sleep per day
  final double sleepHours = 8.0;

  @override
  void initState() {
    super.initState();
    // Update the time every second
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  Map<String, dynamic> calculateRemainingTime() {
    if (birthDate == null) {
      return {
        'totalLifeSeconds': 0,
        'elapsedSeconds': 0,
        'remainingSeconds': 0,
        'remainingYears': 0,
        'remainingDays': 0,
        'remainingHours': 0,
        'remainingMinutes': 0,
        'remainingAwakeHours': 0,
        'percentageElapsed': 0.0,
      };
    }

    // Calculate age and remaining time
    final totalLifeSeconds = (lifeExpectancy * 365.25 * 24 * 60 * 60).round();
    final elapsedSeconds = currentTime.difference(birthDate!).inSeconds;
    final remainingSeconds = totalLifeSeconds - elapsedSeconds;
    
    // Convert to various time units
    final remainingYears = remainingSeconds / (365.25 * 24 * 60 * 60);
    final remainingDays = remainingSeconds / (24 * 60 * 60);
    final remainingHours = remainingSeconds / (60 * 60);
    final remainingMinutes = remainingSeconds / 60;
    
    // Calculate aware time (subtracting sleep)
    final awakeHoursPerDay = 24 - sleepHours;
    final remainingAwakeHours = remainingHours * (awakeHoursPerDay / 24);
    
    // Calculate percentage elapsed
    final percentageElapsed = elapsedSeconds / totalLifeSeconds;
    
    return {
      'totalLifeSeconds': totalLifeSeconds,
      'elapsedSeconds': elapsedSeconds,
      'remainingSeconds': remainingSeconds,
      'remainingYears': remainingYears,
      'remainingDays': remainingDays,
      'remainingHours': remainingHours,
      'remainingMinutes': remainingMinutes,
      'remainingAwakeHours': remainingAwakeHours,
      'percentageElapsed': percentageElapsed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final timeData = calculateRemainingTime();
    final formatter = NumberFormat("#,###");
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Clock'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Birth date selection
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    birthDate == null 
                      ? 'Select Birth Date' 
                      : 'Birth Date: ${DateFormat('MMM d, yyyy').format(birthDate!)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Display pie chart only if birth date is selected
              if (birthDate != null) ...[
                // Current time display
                Text(
                  DateFormat('h:mm:ss a').format(currentTime),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Life clock pie chart
                SizedBox(
                  height: 250,
                  width: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: CircularProgressIndicator(
                          value: timeData['percentageElapsed'],
                          strokeWidth: 20,
                          backgroundColor: Colors.grey[700],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            HSLColor.fromAHSL(
                              1.0,
                              (120 * (1 - timeData['percentageElapsed'])).toDouble(), // Hue goes from green to red
                              0.8,
                              0.5,
                            ).toColor(),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(timeData['percentageElapsed'] * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'of life elapsed',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Remaining time displays
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Remaining Time',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Years remaining
                      RemainingTimeRow(
                        title: 'Years:',
                        value: formatter.format(timeData['remainingYears'].floor()),
                        decimals: timeData['remainingYears'].toStringAsFixed(2).split('.')[1],
                      ),
                      
                      // Days remaining
                      RemainingTimeRow(
                        title: 'Days:',
                        value: formatter.format(timeData['remainingDays'].floor()),
                        decimals: timeData['remainingDays'].toStringAsFixed(2).split('.')[1],
                      ),
                      
                      // Hours remaining
                      RemainingTimeRow(
                        title: 'Hours:',
                        value: formatter.format(timeData['remainingHours'].floor()),
                        decimals: timeData['remainingHours'].toStringAsFixed(2).split('.')[1],
                      ),
                      
                      const Divider(height: 30),
                      
                      // Aware hours (minus sleep)
                      RemainingTimeRow(
                        title: 'Aware Hours:',
                        value: formatter.format(timeData['remainingAwakeHours'].floor()),
                        decimals: timeData['remainingAwakeHours'].toStringAsFixed(2).split('.')[1],
                        description: '(excluding ${sleepHours.toStringAsFixed(0)} hours of sleep per day)',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Based on a life expectancy of ${lifeExpectancy.toStringAsFixed(0)} years',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              
              // Show message if birth date is not selected
              if (birthDate == null)
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'Select your birth date to view your life clock',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemainingTimeRow extends StatelessWidget {
  final String title;
  final String value;
  final String decimals;
  final String? description;

  const RemainingTimeRow({
    Key? key,
    required this.title,
    required this.value,
    required this.decimals,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      '.$decimals',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                if (description != null)
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}